"""
Gemini Tools Definition
This file defines the functions that will be exposed to Gemini as tools.
"""

import google.generativeai as genai
from google.generativeai import types

# Example Function Declaration using Python SDK
# Gemini SDK automatically generates the schema from the type hints and docstring.

def example_tool(param: str) -> str:
    """
    An example tool that processes a string parameter.
    
    Args:
        param: The input string to process.
        
    Returns:
        A processed string result.
    """
    # Implement your logic here
    return f"Processed: {param}"

# List of tools to be registered
tools_list = [example_tool]

# If using raw FunctionDeclaration (Advanced)
custom_tool_declaration = types.FunctionDeclaration(
    name="custom_action",
    description="Performs a custom action",
    parameters={
        "type": "OBJECT",
        "properties": {
            "location": {
                "type": "STRING",
                "description": "The target location"
            }
        },
        "required": ["location"]
    }
)
