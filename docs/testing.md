# Testing

This document describes the testing approach for Montrose.

## General Approach

Montrose tests utilize the Halstead local provider to simulate Belmont resource interactions without relying on external HTTP endpoints. 
The tests verify that the `Resource` class correctly resolves locators, observes updates, and mutates state. 
The tests also demonstrate how Montrose integrates into a component model lifecycle.

## Running Tests

To run the test suite, use the following command:

```bash
npx genie test
```

This command invokes the Genie task runner to execute the test suite using the Amen testing framework.
