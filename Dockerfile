FROM astrocrpublic.azurecr.io/runtime:3.2-4

# Install dbt
RUN pip install -r requirements.txt