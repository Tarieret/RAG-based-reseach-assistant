# RAG-Based Research Assistant

Medical research on brain tumor detection is spread across dozens of dense PDFs, and finding a specific result by hand is slow. A plain LLM can make up findings or citations. This assistant answers natural-language questions using only passages retrieved from the indexed papers, and cites its sources.

![Streamlit demo](Images/rag-demo-full.gif)

## Key results
- 20 peer-reviewed papers (478 pages) indexed into 2,183 text chunks
- Responses in 2–5 seconds on average
- Every answer cites the source papers it drew from

## How it works
PDFs → PyPDF parsing → chunking → OpenAI embeddings → ChromaDB
User question → Streamlit → FastAPI → ChromaDB retrieval → GPT-4o-mini → answer + citations

- **Semantic search:** chunks are retrieved by embedding similarity rather than keyword match. Dense medical terminology needs conceptual matching, not exact-string matching.
- **Grounded answers:** the system prompt restricts the model to the retrieved passages and requires citations.
- **Separate backend and frontend:** a FastAPI backend and a Streamlit frontend, instead of a single notebook demo. This keeps retrieval logic out of the UI.
- **Session memory:** follow-up questions keep the conversation's context.

## What broke
When retrieved context was thin, early prompt versions let the model fill gaps from its own general medical knowledge. The result was fluent answers that couldn't be traced to any indexed paper. I rewrote the system prompt to tell the model to answer only from the retrieved chunks and to say when they don't contain the answer. This reduces the risk at the source, rather than trying to filter bad output after generation. It doesn't remove the risk entirely.

## Background
The idea came from a Spring 2025 master's project on deep learning for brain tumor detection from MRI images. That project shifted my focus from individual models to supporting the research workflow itself.

## Stack
Python · FastAPI · Uvicorn · LangChain · ChromaDB · OpenAI API (GPT-4o-mini, text-embedding-3-small) · PyPDF · Streamlit

*For research and educational use only; not suitable for clinical or diagnostic decisions.*
