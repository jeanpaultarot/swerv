import cocotb
from cocotb.triggers import RisingEdge, Event
from cocotb.clock import Clock
from cocotb_coverage import crv
from cocotb_coverage.coverage import *

NUM_EXECUTIONS = 10
SIGNAL_LENGTH = 32
NUMBER_OF_RESETS = 5

# Generates random values for signal_delayed and signal_to_delay
class rand_vals(crv.Randomized):
    def __init__(self, _range):
        crv.Randomized.__init__(self)
        self.signal_to_delay = 0
        self.signal_delayed = 0
        self.add_rand("signal_to_delay", list(range(_range)))
        self.add_rand("signal_delayed", list(range(_range)))

@CoverPoint("top.signal_to_delay",
            xf = lambda rl : rl.signal_to_delay,
            bins = range(1,2**SIGNAL_LENGTH))
def sample_coverage(rl):
    pass

@CoverPoint("top.signal_delayed",
            xf = lambda rl : rl.signal_delayed,
            bins = range(1,2**SIGNAL_LENGTH))
def sample_coverage(rl):
    pass

class TestBench:
    
    ## dut = design under test
    def __init__(self, dut, num_executions):
        self.dut = dut
        self.num_executions = num_executions
        self.in_vals = Event()  # Event to communicate Driver and ReferenceModel
        self.out_vals = Event() # Event to communicate ReferenceModel and Checker
        self.ref_equal = 0     

    @cocotb.coroutine
    def Driver(self):
        self.dut.rst <= 1
        yield RisingEdge(self.dut.clk)
        yield RisingEdge(self.dut.clk)
        self.dut.rst <= 0
        vals = rand_vals(2**SIGNAL_LENGTH)
        for _ in range(self.num_executions):
            vals.randomize() # Randomize values of the vectors
            self.dut.signal_to_delay <= vals.signal_to_delay
            self.dut.signal_delayed <= vals.signal_delayed
            self.in_vals.set((vals.signal_to_delay, vals.signal_delayed))
            yield RisingEdge(self.dut.clk)
            sample_coverage(vals)

    @cocotb.coroutine
    def ReferenceModel(self):
        ref_signal_to_delay_delayed_1 = 0
        ref_signal_to_delay_delayed_2 = 0
        ref_signal_to_delay_delayed_3 = 0
        for _ in range(self.num_executions):
            yield self.in_vals.wait()
            ref_signal_to_delay_delayed_3 = ref_signal_to_delay_delayed_2
            ref_signal_to_delay_delayed_2 = ref_signal_to_delay_delayed_1
            ref_signal_to_delay_delayed_1 = self.in_vals.data[0]
            self.ref_equal = (ref_signal_to_delay_delayed_3 == self.in_vals.data[1])
            self.out_vals.set(self.ref_equal)
            self.in_vals.clear()          

    @cocotb.coroutine
    def Checker(self, ref_th):
        for _ in range(self.num_executions):
            yield self.out_vals.wait()
            cocotb.log.info(" ref_equal={0}, dut_equal={1}".format(self.ref_equal, int(self.dut.equal.value)))
            assert self.dut.equal == self.ref_equal
            self.out_vals.clear()

    @cocotb.coroutine
    def run(self):
        cocotb.fork(self.Driver())
        ref_th = cocotb.fork(self.ReferenceModel())
        yield cocotb.fork(self.Checker(ref_th)).join()
        

@cocotb.test()
def comparator_test(dut):
    cocotb.fork(Clock(dut.clk, 10, "ns").start())
    cocotb.log.info("Running {0} tests".format(NUM_EXECUTIONS * NUMBER_OF_RESETS))
    for i in range(NUMBER_OF_RESETS):
        cocotb.log.info("Test {0} : Running {1} tests".format(NUMBER_OF_RESETS, NUM_EXECUTIONS))
        tb = TestBench(dut, NUM_EXECUTIONS)
        yield tb.run()
    coverage_db.report_coverage(cocotb.logging.getLogger("cocotb.test").info, bins=True)
