describe 'integration test cases' do
  testcases = YAML.load_file 'spec/docopt/cases.yml'

  testcases.each_with_index do |testcase, i|
    describe "Test Case #{i}" do
      doc = testcase['docopt']
      
      testcase['commands'].each do |command, output|
        argv = Shellwords.split(command)[1..]
        describe "$ #{command}" do
          it "equals #{output}" do
            expect(runner(doc, argv)).to eq output
          end
        end
      end  
    end
  end
end
