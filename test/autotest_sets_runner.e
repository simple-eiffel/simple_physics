note
	description: "[
		Runs the tests in simple_physics's AutoTest test sets that TEST_APP did not call
		(port-coordination #17: 5 of them ran in no gate). Each goes through AutoTest's own
		EQA_TEST_EVALUATOR: a fresh test set (on_prepare), the test, then clean (on_clean),
		as AutoTest runs it. A failing test prints "FAIL:" with its tag and is counted.
	]"

class
	AUTOTEST_SETS_RUNNER

feature -- Counts

	passed, failed: INTEGER
			-- Tests run here.

feature -- Running

	run_all
			-- Every test below, 5 in all.
		do
			run_lib_tests
			run_test_simple_physics
		end

feature {NONE} -- Test sets

	run_lib_tests
		local
			l_evaluator: EQA_TEST_EVALUATOR [LIB_TESTS]
		do
			create l_evaluator
			report (l_evaluator.execute (agent {LIB_TESTS}.test_all), "LIB_TESTS.test_all")
			report (l_evaluator.execute (agent {LIB_TESTS}.test_vectors), "LIB_TESTS.test_vectors")
			report (l_evaluator.execute (agent {LIB_TESTS}.test_bodies), "LIB_TESTS.test_bodies")
			report (l_evaluator.execute (agent {LIB_TESTS}.test_world), "LIB_TESTS.test_world")
		end

	run_test_simple_physics
		local
			l_evaluator: EQA_TEST_EVALUATOR [TEST_SIMPLE_PHYSICS]
		do
			create l_evaluator
			report (l_evaluator.execute (agent {TEST_SIMPLE_PHYSICS}.test_set_gravity_negative), "TEST_SIMPLE_PHYSICS.test_set_gravity_negative")
		end

feature {NONE} -- Implementation

	report (a_result: EQA_PARTIAL_RESULT; a_name: STRING)
			-- Count and print `a_result' of test `a_name'.
		do
			if a_result.is_pass then
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			else
				print ("  FAIL: " + a_name + " [" + {UTF_CONVERTER}.string_32_to_utf_8_string_8 (a_result.tag) + "]%N")
				failed := failed + 1
			end
		end

end
