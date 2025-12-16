FROM python:3.10-slim

WORKDIR /app
RUN pip install flask

COPY app.py .

EXPOSE 6080
CMD ["python", "app.py"]
