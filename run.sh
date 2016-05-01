#!/bin/bash

PROJECT_NAME="elixir_mix_bug"
rm -rf ${PROJECT_NAME}/
git clone https://github.com/eksperimental/${PROJECT_NAME}.git
cd ${PROJECT_NAME}

printf "\n************************************************************************\n"
echo "*** STEP ONE ***"
echo "****************"
echo ">>> Tests pass, even though 2 moduels share the name and one test in them should fail"
for i in $(seq 10); do echo "#${i}"; mix test; done

printf "\n************************************************************************\n"
echo "*** STEP TWO ***"
echo "****************"
echo ">>> Let's run it 500 times, and eventually it will give a CompileError"
mix
for i in $(seq 500); do echo "#${i}"; mix test 2>&1 >/dev/null | grep -v warning; done

printf "\n************************************************************************\n"
echo "*** STEP THREE ***"
echo "******************"
echo ">>> Let's reorder (by renaming) the files, and to see how this affects the results"
echo ">>> Now the rule is that it will give CompileError, with few exceptions building"
mv test/a_another_test.exs test/z_another_test.exs 
ls -l test/
for i in $(seq 10); do echo "#${i}"; mix test 2>&1 >/dev/null | grep -v warning; done
mv test/z_another_test.exs test/a_another_test.exs

printf "\n************************************************************************\n"
echo "*** STEP FOUR ***"
echo "*****************"
echo ">>> Let's rename the conflicting tests"
echo ">>> and now tests fail every time"
mv test/c_fail_test.exs test/e_fail_test.exs
for i in $(seq 10); do echo "#${i}"; mix test; done
mv test/e_fail_test.exs test/c_fail_test.exs  

printf "\n************************************************************************\n"
echo "*** STEP FIVE ***"
echo "*****************"
echo ">>> Now tests pass again as initially happened"
for i in $(seq 10); do echo "#${i}"; mix test 2>&1 >/dev/null | grep -v warning; done

printf "\n************************************************************************\n"
echo "*** FINISHED ***"
echo "****************"