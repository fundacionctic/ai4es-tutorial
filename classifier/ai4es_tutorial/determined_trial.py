import keras
from determined.keras import TFKerasTrial, TFKerasTrialContext


class FashionMNISTTrial(TFKerasTrial):
    def __init__(self, context: TFKerasTrialContext):
        self.context = context

    def build_model(self):
        model = keras.Sequential(
            [
                keras.layers.Flatten(input_shape=(28, 28)),
                keras.layers.Dense(
                    self.context.get_hparam("dense1"), activation="relu"
                ),
                keras.layers.Dense(10),
            ]
        )

        # Wrap the model.
        model = self.context.wrap_model(model)

        # Create and wrap optimizer.
        optimizer = tf.keras.optimizers.Adam()
        optimizer = self.context.wrap_optimizer(optimizer)

        model.compile(
            optimizer=optimizer,
            loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
            metrics=[tf.keras.metrics.SparseCategoricalAccuracy(name="accuracy")],
        )

        return model

    def build_training_data_loader(self):
        # Create the training data loader. This should return a keras.Sequence,
        # a tf.data.Dataset, or NumPy arrays.
        pass

    def build_validation_data_loader(self):
        # Create the validation data loader. This should return a keras.Sequence,
        # a tf.data.Dataset, or NumPy arrays.
        pass
