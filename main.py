import logging

# import yaml
# import mlflow
# import mlflow.sklearn
from steps.ingest import Ingestion
from steps.clean import Cleaner
from steps.train import Trainer
from steps.predict import Predictor

# from sklearn.metrics import classification_report

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s:%(levelname)s:%(message)s")


def main():
    # Load data
    ingestion = Ingestion()
    train, test = ingestion.load_data()
    logging.info("Data ingestion completed successfully")

    # Clean data
    cleaner = Cleaner()
    train_data = cleaner.clean_data(train)
    test_data = cleaner.clean_data(test)
    logging.info("Data cleaning completed successfully")

    # Prepare and train model
    trainer = Trainer()
    X_train, y_train = trainer.feature_target_separator(train_data)
    trainer.train_model(X_train, y_train)
    trainer.save_model()
    logging.info("Model training completed successfully")

    # Evaluate model
    predictor = Predictor()
    X_test, y_test = predictor.feature_target_separator(test_data)
    accuracy, class_report, roc_auc_score = predictor.evaluate_model(X_test, y_test)
    logging.info("Model evaluation completed successfully")

    # Print evaluation results
    print("\n============= Model Evaluation Results ==============")
    print(f"Model: {trainer.model_name}")
    print(f"Accuracy Score: {accuracy:.4f}, ROC AUC Score: {roc_auc_score:.4f}")
    print(f"\n{class_report}")
    print("=====================================================\n")


if __name__ == "__main__":
    main()
    # train_with_mlflow()
