Given('valid ResultsDatum model') do
  ResultsDatum.create(subject: 'java', timestamp: '2022-04-18 12:02:44.678', marks: 123.54)
end
Then('check presense of subject') do
  expect(ResultsDatum.first).to validate_presence_of(:subject)
end
Then('check presense of timestamp') do
  expect(ResultsDatum.first).to validate_presence_of(:timestamp)
end
Then('check presense of marks') do
  expect(ResultsDatum.first).to validate_presence_of(:marks)
end
