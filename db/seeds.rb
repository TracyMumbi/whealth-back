# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

project1 = Project.create!(
  name: "Antenatal/Obstetrics Services",
  body: "Comprehensive care for expecting mothers, including regular check-ups, ultrasounds, and prenatal education. Our services ensure the health and well-being of both mother and baby throughout the pregnancy journey."
)

project2 = Project.create!(
  name: "Child Development Milestone Tracking",
  body: "Monitor and support your child's growth and development from birth to early childhood. Our platform provides tools to track key milestones, ensuring your child is on the right path to a healthy and successful future."
)

project3 = Project.create!(
  name: "Radiology Services",
  body: "State-of-the-art imaging services including X-rays, MRIs, and ultrasounds. Our radiology department ensures accurate diagnosis and effective treatment planning with advanced technology and expert analysis."
)

project4 = Project.create!(
  name: "Immunization Services",
  body: "Protect your family from preventable diseases with our comprehensive immunization services. We provide vaccines for children, adults, and travel, adhering to the latest guidelines for public health safety."
)

project5 = Project.create!(
  name: "Prescription/Pharmacy Services",
  body: "Convenient and reliable prescription services. Order your medications online and have them delivered to your door, or pick them up at our pharmacy. Our pharmacists are available for consultations and advice."
)

project6 = Project.create!(
  name: "Lab Requests and Results",
  body: "Easily request lab tests and receive your results online. Our lab services cover a wide range of tests, from routine blood work to specialized diagnostics, with fast and accurate reporting."
)

project7 = Project.create!(
  name: "Nutrition Services",
  body: "Personalized nutrition counseling and meal planning to support your health goals. Whether you need help managing a chronic condition or want to improve your overall well-being, our nutrition experts are here to guide you."
)

project8 = Project.create!(
  name: "Check-ups and Wellness",
  body: "Regular health check-ups and wellness visits to keep you in the best possible shape. Our comprehensive exams and screenings help detect potential health issues early, ensuring timely intervention and peace of mind."
)

project9 = Project.create!(
  name: "Information Portal",
  body: "Access a wealth of health information and resources through our online portal. Stay informed about the latest medical developments, wellness tips, and health news to make educated decisions about your care."
)
