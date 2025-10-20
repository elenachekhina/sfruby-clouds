Participant.create!(
  full_name: "Vova Dem",
  email: "palkan@evilmartians.com"
).tap do
  cloud = it.clouds.generated.create!(picked: true)
  cloud.generated_image.attach(
    io: Rails.root.join("spec/fixtures/files/vova.png").open,
    filename: "generated-vova.png"
  )
end

Participant.create!(
  full_name: "Ira Nazarova",
  email: "inazarova@evilmartians.com"
)
