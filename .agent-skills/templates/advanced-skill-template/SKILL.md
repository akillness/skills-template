---
name: advanced-skill-template
description: Comprehensive description of what this skill does and when to use it. Include technologies, use cases, and any special requirements or dependencies.
allowed-tools: Read, Write, Grep, Glob
---

# Advanced Skill Name

## Overview

Detailed overview of what this skill provides and why it's useful.

This skill helps with:
- Key capability 1
- Key capability 2
- Key capability 3

## Prerequisites

Before using this skill, ensure you have:

### Required
- Requirement 1 (e.g., Python 3.8+)
- Requirement 2 (e.g., Node.js 14+)
- Requirement 3 (e.g., Docker installed)

### Optional
- Optional tool 1
- Optional tool 2

### Dependencies

```bash
# Python dependencies
pip install package1 package2

# Node.js dependencies
npm install package3 package4
```

## When to use this skill

- **Use case 1**: Detailed scenario description
- **Use case 2**: Another scenario with context
- **Use case 3**: Additional use case
- **Use case 4**: Edge case scenario

## Quick Start

Get started quickly with this basic example:

```bash
# Setup
./scripts/setup.sh

# Basic usage
python scripts/main.py --config config.yaml

# Verify
./scripts/verify.sh
```

## Instructions

### Part 1: Initial Setup

#### Step 1: Environment preparation
Prepare your environment:

```bash
# Create directory structure
mkdir -p project/{src,tests,config}

# Initialize configuration
cp templates/config.yaml project/config/
```

#### Step 2: Configuration
Edit the configuration file:

```yaml
# config.yaml
setting1: value1
setting2: value2
options:
  option1: true
  option2: false
```

### Part 2: Implementation

#### Step 3: Core implementation
Implement the main functionality:

```language
# Detailed implementation example
class MainImplementation:
    def __init__(self, config):
        self.config = config
        self.state = {}
    
    def process(self, input_data):
        """
        Process input data according to configuration.
        
        Args:
            input_data: Data to process
            
        Returns:
            Processed result
            
        Raises:
            ValueError: If input is invalid
        """
        # Validation
        if not self.validate(input_data):
            raise ValueError("Invalid input")
        
        # Processing
        result = self.transform(input_data)
        
        # Post-processing
        return self.finalize(result)
    
    def validate(self, data):
        # Validation logic
        return True
    
    def transform(self, data):
        # Transformation logic
        return data
    
    def finalize(self, result):
        # Finalization logic
        return result
```

#### Step 4: Integration
Integrate with existing systems:

See [INTEGRATION.md](INTEGRATION.md) for detailed integration guide.

### Part 3: Testing

#### Step 5: Unit tests
Write comprehensive unit tests:

```language
# test_main.py
import unittest

class TestMainImplementation(unittest.TestCase):
    def setUp(self):
        self.impl = MainImplementation(test_config)
    
    def test_basic_processing(self):
        """Test basic processing workflow."""
        result = self.impl.process(test_data)
        self.assertEqual(result, expected_result)
    
    def test_error_handling(self):
        """Test error cases."""
        with self.assertRaises(ValueError):
            self.impl.process(invalid_data)
    
    def test_edge_cases(self):
        """Test edge cases."""
        # Edge case testing
        pass
```

#### Step 6: Integration tests
Test the complete workflow:

```bash
# Run integration tests
./scripts/test_integration.sh
```

### Part 4: Deployment

#### Step 7: Production deployment
Deploy to production:

See [DEPLOYMENT.md](DEPLOYMENT.md) for deployment procedures.

```bash
# Build
./scripts/build.sh

# Deploy
./scripts/deploy.sh production

# Verify deployment
./scripts/verify_deployment.sh
```

## Detailed Examples

### Example 1: Basic Usage

**Scenario**: Simple use case

```language
# Complete working example
from main import MainImplementation

# Initialize
config = load_config('config.yaml')
impl = MainImplementation(config)

# Process
input_data = prepare_input()
result = impl.process(input_data)

# Handle result
save_result(result)
```

**Expected output**:
```
Processing complete: 100 items processed
Results saved to output.json
```

### Example 2: Advanced Usage

**Scenario**: Complex workflow with error handling

```language
# Advanced example with error handling
from main import MainImplementation
import logging

logging.basicConfig(level=logging.INFO)

class AdvancedWorkflow:
    def __init__(self):
        self.config = load_config('config.yaml')
        self.impl = MainImplementation(self.config)
        self.logger = logging.getLogger(__name__)
    
    def run(self):
        """Run the complete workflow."""
        try:
            # Step 1: Prepare
            self.logger.info("Preparing data...")
            data = self.prepare()
            
            # Step 2: Process
            self.logger.info("Processing...")
            result = self.impl.process(data)
            
            # Step 3: Validate
            self.logger.info("Validating results...")
            if self.validate_result(result):
                self.save(result)
                self.logger.info("Workflow complete!")
            else:
                raise ValueError("Validation failed")
                
        except Exception as e:
            self.logger.error(f"Workflow failed: {e}")
            self.handle_error(e)
            raise
    
    def prepare(self):
        # Preparation logic
        pass
    
    def validate_result(self, result):
        # Validation logic
        return True
    
    def save(self, result):
        # Save logic
        pass
    
    def handle_error(self, error):
        # Error handling
        pass

if __name__ == '__main__':
    workflow = AdvancedWorkflow()
    workflow.run()
```

### Example 3: Real-world Scenario

**Scenario**: Production use case

See [examples/production_example.py](examples/production_example.py)

## Best Practices

### Performance

1. **Optimization 1**: Cache frequently accessed data
   ```language
   # Use caching for expensive operations
   from functools import lru_cache
   
   @lru_cache(maxsize=128)
   def expensive_operation(param):
       # Expensive computation
       pass
   ```

2. **Optimization 2**: Batch processing for efficiency
   - Process items in batches of 100-1000
   - Use connection pooling for databases
   - Implement rate limiting for APIs

3. **Optimization 3**: Async operations where possible
   ```language
   async def async_process(items):
       tasks = [process_item(item) for item in items]
       results = await asyncio.gather(*tasks)
       return results
   ```

### Security

1. **Security 1**: Input validation
   - Validate all user inputs
   - Sanitize data before processing
   - Use parameterized queries

2. **Security 2**: Secrets management
   - Never hardcode secrets
   - Use environment variables or secret managers
   - Rotate credentials regularly

3. **Security 3**: Error handling
   - Don't expose sensitive information in errors
   - Log securely
   - Implement rate limiting

### Maintainability

1. **Maintainability 1**: Clear documentation
   - Document all public APIs
   - Include usage examples
   - Keep docs up-to-date

2. **Maintainability 2**: Comprehensive testing
   - Unit tests for all functions
   - Integration tests for workflows
   - Test edge cases

3. **Maintainability 3**: Code organization
   - Follow single responsibility principle
   - Use clear naming conventions
   - Keep functions small and focused

## Common Issues

### Issue 1: Performance degradation

**Symptoms**: 
- Slow processing times
- High memory usage
- CPU spikes

**Diagnosis**:
```bash
# Profile the application
python -m cProfile script.py

# Check memory usage
python -m memory_profiler script.py
```

**Resolution**:
1. Implement caching
2. Use batch processing
3. Optimize database queries
4. Consider async processing

### Issue 2: Configuration errors

**Symptoms**:
- Application fails to start
- Unexpected behavior
- Missing features

**Diagnosis**:
```bash
# Validate configuration
python scripts/validate_config.py config.yaml
```

**Resolution**:
1. Check configuration syntax
2. Verify all required fields
3. Validate file paths
4. Check environment variables

### Issue 3: Integration failures

**Symptoms**:
- Connection timeouts
- Authentication errors
- Data format mismatches

**Diagnosis**:
See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

**Resolution**:
1. Verify network connectivity
2. Check credentials
3. Validate data formats
4. Review API versions

## Monitoring and Observability

### Metrics to track

```python
# Example metrics
metrics = {
    'requests_total': counter,
    'requests_duration': histogram,
    'active_connections': gauge,
    'errors_total': counter
}
```

### Logging

```python
# Structured logging
import logging
import json

logger = logging.getLogger(__name__)

def log_operation(operation, **kwargs):
    logger.info(json.dumps({
        'operation': operation,
        'timestamp': datetime.now().isoformat(),
        **kwargs
    }))
```

### Alerts

Set up alerts for:
- Error rate > 5%
- Response time > 1s
- Memory usage > 80%
- Disk usage > 90%

## Supporting Files

### Scripts

- [setup.sh](scripts/setup.sh): Initial setup
- [main.py](scripts/main.py): Main application
- [test.sh](scripts/test.sh): Run tests
- [deploy.sh](scripts/deploy.sh): Deployment script

### Templates

- [config.yaml](templates/config.yaml): Configuration template
- [docker-compose.yml](templates/docker-compose.yml): Docker setup

### Documentation

- [REFERENCE.md](REFERENCE.md): Detailed API reference
- [INTEGRATION.md](INTEGRATION.md): Integration guide
- [DEPLOYMENT.md](DEPLOYMENT.md): Deployment guide
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md): Troubleshooting guide

## Version History

### v2.0.0 (2024-02-01)
- Added async processing
- Improved error handling
- Updated dependencies

### v1.1.0 (2024-01-15)
- Added batch processing
- Performance improvements
- Bug fixes

### v1.0.0 (2024-01-01)
- Initial release

## References

### Official Documentation
- [Main Documentation](https://docs.example.com)
- [API Reference](https://api.example.com/docs)

### Tutorials
- [Getting Started Tutorial](https://tutorial.example.com)
- [Advanced Usage Guide](https://guide.example.com)

### Community
- [GitHub Repository](https://github.com/example/repo)
- [Community Forum](https://forum.example.com)
- [Stack Overflow Tag](https://stackoverflow.com/questions/tagged/example)

### Standards
- [RFC xxxx](https://tools.ietf.org/html/rfcxxxx)
- [Industry Standard](https://standard.example.com)

