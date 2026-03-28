import gradio as gr
from openai import OpenAI
import os

# ================== CHANGE THESE TWO LINES ONLY ==================
client = OpenAI(
    api_key=os.getenv("GROQ_API_KEY"),   # ← SET YOUR GROQ KEY AS ENVIRONMENT VARIABLE
    base_url="https://api.groq.com/openai/v1"
)

model = "llama-3.3-70b-versatile"   # Fast & powerful free model
# =================================================================

def chatbot(message, history):
    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "system", "content": "You are a recipe assistant bot. You only provide recipes for food. If the user asks about anything else, politely decline and suggest asking for a recipe instead."}] + [{"role": m["role"], "content": m["content"]} for m in history] + [{"role": "user", "content": message}],
        temperature=0.7,
        max_tokens=1024
    )
    return response.choices[0].message.content

# Custom CSS for enhanced styling
custom_css = """
    body {
        font-family: 'Segoe UI', 'Helvetica Neue', Arial, sans-serif;
    }
    
    .gradio-container {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 20px;
    }
    
    .gr-box {
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    }
    
    .gr-textbox, .gr-button {
        border-radius: 8px;
        border: none;
    }
    
    .gr-button {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        font-weight: 600;
        transition: all 0.3s ease;
    }
    
    .gr-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 16px rgba(102, 126, 234, 0.4);
    }
    
    .message.user {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 12px 0 12px 12px;
    }
    
    .message.assistant {
        background: #f0f0f0;
        border-radius: 0 12px 12px 12px;
    }
    
    h1 {
        color: white;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        font-size: 2.5em;
        margin-bottom: 10px;
    }
    
    .gr-prose p {
        color: rgba(255, 255, 255, 0.9);
        font-size: 1.1em;
    }
"""

# Create the enhanced interface
with gr.Blocks() as demo:
    
    # Header section
    with gr.Group():
        gr.Markdown(
            """
            #  Recipe Assistant
            **Powered by LLaMA 3.3 70B** • *Free, fast, unlimited for personal use*
            
            Experience lightning-fast AI conversations with cutting-edge technology.
            """
        )
    
    # Chat interface
    chatbot_interface = gr.ChatInterface(
        chatbot,
        examples=[
            "Give me a recipe for chocolate chip cookies",
            "How to make spaghetti carbonara?",
            "Recipe for vegetable stir-fry",
            "Simple chicken curry recipe"
        ],
        description="Type your message below and press Enter or click Send",
    )

demo.launch(css=custom_css, theme=gr.themes.Soft(
    primary_hue="purple",
    secondary_hue="pink"
))