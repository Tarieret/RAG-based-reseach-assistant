#!/bin/bash
# Startup script for RAG Research Assistant
# This script starts both the FastAPI backend and Streamlit frontend

echo "🚀 Starting RAG Research Assistant..."
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "Please run: python -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

# Check for OpenAI API key
if [ -z "$OPENAI_API_KEY" ]; then
    echo "⚠️  WARNING: OPENAI_API_KEY environment variable not set!"
    echo "Please set it: export OPENAI_API_KEY='your-key-here'"
    echo ""
fi

# Activate virtual environment
source venv/bin/activate

# Start FastAPI backend in background
echo "🔧 Starting FastAPI backend on http://localhost:8000..."
uvicorn backend.main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
echo "   Backend PID: $BACKEND_PID"

# Wait for backend to start
sleep 3

# Start Streamlit frontend
echo "🎨 Starting Streamlit frontend on http://localhost:8501..."
streamlit run frontend/streamlit_app.py &
FRONTEND_PID=$!
echo "   Frontend PID: $FRONTEND_PID"

echo ""
echo "✅ Both servers are running!"
echo ""
echo "📍 Access points:"
echo "   - Streamlit UI: http://localhost:8501"
echo "   - FastAPI Docs: http://localhost:8000/docs"
echo "   - API Health:   http://localhost:8000/health"
echo ""
echo "Press Ctrl+C to stop both servers..."
echo ""

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping servers..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    echo "✅ Servers stopped. Goodbye!"
    exit 0
}

# Trap Ctrl+C
trap cleanup INT

# Wait for both processes
wait
