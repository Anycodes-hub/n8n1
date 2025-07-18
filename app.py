from riffusion import RiffusionModel
model = RiffusionModel.from_pretrained("riffusion/riffusion")
audio = model.generate("uplifting cinematic piano", duration=30)
with open("output.wav","wb") as f:
    f.write(audio)
print("Audio generated")
