import logging
import random

import coloredlogs
import numpy as np
import tensorflow as tf

_CLASS_NAMES = [
    "T-shirt/top",
    "Trouser",
    "Pullover",
    "Dress",
    "Coat",
    "Sandal",
    "Shirt",
    "Sneaker",
    "Bag",
    "Ankle boot",
]

_EPOCHS = 10
_NUM_LOG_TESTS = 15

_logger = logging.getLogger(__name__)


def main():
    _logger.info("Downloading Fashion MNIST dataset")

    fashion_mnist = tf.keras.datasets.fashion_mnist
    (train_images, train_labels), (test_images, test_labels) = fashion_mnist.load_data()
    train_images = train_images / 255.0
    test_images = test_images / 255.0

    model = tf.keras.Sequential(
        [
            tf.keras.layers.Flatten(input_shape=train_images[0].shape),
            tf.keras.layers.Dense(128, activation="relu"),
            tf.keras.layers.Dense(10),
        ]
    )

    _logger.info("Compiling model")

    model.compile(
        optimizer="adam",
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
        metrics=["accuracy"],
    )

    _logger.info("Training model")

    model.fit(train_images, train_labels, epochs=_EPOCHS)
    test_loss, test_acc = model.evaluate(test_images, test_labels, verbose="2")

    _logger.info("Test loss value: %s", test_loss)
    _logger.info("Test accuracy: %s", test_acc)

    probability_model = tf.keras.Sequential([model, tf.keras.layers.Softmax()])
    predictions = probability_model.predict(test_images)

    for _ in range(_NUM_LOG_TESTS):
        rand_idx = random.randrange(0, len(predictions))
        prediction_class = np.argmax(predictions[rand_idx])
        truth_class = test_labels[rand_idx]

        _logger.debug(
            "Item #%s - Prediction: %s (%s) - Ground truth: %s (%s)",
            rand_idx,
            prediction_class,
            _CLASS_NAMES[prediction_class],
            truth_class,
            _CLASS_NAMES[truth_class],
        )


if __name__ == "__main__":
    coloredlogs.install(level=logging.DEBUG)
    main()
