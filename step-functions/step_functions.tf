// with the help of step function, we can model the workflows as state machines
// the definition of step functions is written in JSON format
// it can be started with SDK call or from console or using eventbridge

// so using step function we can create workflows as per our need
// we may have different individual tasks, and those tasks may have dependency between each other.
// so if we modelled them as a workflow using state machine, then they can be executed perfectly.
// we may need to begin a task by checking some condition, those can be done easily using step functions.


// Task states => do some work
// 1. can invoke a aws service like lambda, glue etc.
// 2. can publish message to SNS and SQS
// 3. can invoke another step function

// different states
// 1. choice state => it will test for a condition and based on that it will send the execution to a branch
// 2. Fail or succeed state=> it will stop the execution upon success or failure
// 3. wait state => it will delay the execution by certain time or upto some specified time/date
// 4. pass state => it will simply pass its input to output without doing any work
// 5. map state => it will dynamically iterate steps
// 6. parallel state => it will start parallel branch of execution


// Error handling in Step Function
// Stages in the step function may raise some error due to:
// 1. Runtime error in application code (Lambda, Glue) etc.

// There is no need to handle those expetions inside the application.
// Instead the errors can be throwed ouside that stage and can be handle outside the application code using Step Function Error Handling
// We can use retry and catch for error handling
// there are variours error codes defined like States.ALL, Stats.Timeout etc.

// retry
// using retry, the state can be retriggered, (Task or Parallel)
// after the maximum attems, it sends the error to catch

// catch
// it will handled the error by moving the execution to a different state
// ErrorEquals
// Next
// ResultPath

// ResultPath
// ResultPath will append the parameter to the origin input and will send it to the next state
// "ResultPath": null => it means it will send the origin step function input to its output
// "ResultPath": "$.error-info" => it means it will add the error-info paramter to the original input and will send as output



resource "aws_sfn_state_machine" "first-step-function" {
    name = "First-Step-Function"
    role_arn = "arn:aws:iam::902932105105:role/service-role/StepFunctions-MyStateMachine-role-f1f68940"
    tags = {
      Purpose = "Tutorial",
      Name = "First-Step-Function"
    }
    
    definition = <<EOF
    {
        "Comment": "Demo Step Function",
        "StartAt": "Lambda",
        "States": {
            "Lambda": {
                "Type": "Task",
                "Resource": "arn:aws:lambda:ap-south-1:902932105105:function:DemoLambdaForStepFunction",
                "Parameters": {
                    "exception.$": "$.exception"
                },
                "Retry": [
                    {
                        "ErrorEquals": ["States.ALL"],
                        "BackoffRate": 2,
                        "IntervalSeconds": 2,
                        "MaxAttempts": 3
                    }
                ],
                "Catch": [
                    {
                        "ErrorEquals": ["States.ALL"],
                        "ResultPath": "$.error-info",
                        "Next": "Update as Error"
                    }
                ],
                "ResultPath": null,
                "Next": "Hello"
            },
            "Update as Error": {
                "Type": "Fail"
            },
            "Hello": {
                "Type": "Pass",
                "Next": "Wait needed?"
            },
            "Wait needed?": {
                "Type": "Choice",
                "Choices": [
                    {
                    "Variable": "$.wait_needed",
                    "BooleanEquals": true,
                    "Next": "Wait"
                    },
                    {
                    "Variable": "$.wait_needed",
                    "StringEquals": "true",
                    "Next": "Wait"
                    }
                ],
                "Default": "World"
            },
            "Wait": {
                "Type": "Wait",
                "SecondsPath": "$.wait_seconds",
                "Next": "World"
            },
            "World": {
                "Type": "Pass",
                "Next": "Execution"
            },
            "Execution": {
                "Type": "Parallel",
                "Next": "Is_Error",
                "Branches": [
                    {
                        "StartAt": "Execution 1",
                        "States": {
                            "Execution 1": {
                                "Type": "Pass",
                                "End": true
                            }
                        }
                    },
                    {
                        "StartAt": "Execution 2",
                        "States": {
                            "Execution 2": {
                                "Type": "Pass",
                                "End": true
                            }
                        }
                    }
                    
                ]
            },
            "Is_Error": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$[0].error",
                        "BooleanEquals": true,
                        "Next": "Fail"
                    },
                    {
                        "Variable": "$[0].error",
                        "BooleanEquals": false,
                        "Next": "Success"
                    }
                ]
            },
            "Success": {
                "Type": "Succeed"
            },
            "Fail": {
                "Type": "Fail"
            }         
        }
    } 
    EOF
}
