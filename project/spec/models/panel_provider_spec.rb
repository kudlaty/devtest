require 'rails_helper'

RSpec.describe PanelProvider, type: :model do
  describe "pricing depends on code" do
    context "times_a" do
      let(:panel_provider){ FactoryBot.build(:panel_provider, :times_a) }
      it "should return correct count" do
        response_body = '<nav><ul><li><a href="#nowhere" title="Lorum ipsum dolor sit amet">Lorem</a></li><li><a href="#nowhere" title="Aliquam tincidunt mauris eu risus">Aliquam</a></li><li><a href="#nowhere" title="Morbi in sem quis dui placerat ornare">Morbi</a></li><li><a href="#nowhere" title="Praesent dapibus, neque id cursus faucibus">Praesent</a></li><li><a href="#nowhere" title="Pellentesque fermentum dolor">Pellentesque</a></li></ul></nav>'
        expect(panel_provider.send(:price_times_a, response_body)).to eq 0.23
      end
      it "should return 0 when response_body doesn't have any a letters" do
        response_body = '<div>Lorem ipsum dolor sit Amet</div>'
        expect(panel_provider.send(:price_times_a, response_body)).to eq 0
      end
      it "should raise error when response_body is not String" do
        expect{
          panel_provider.send(:price_times_a, nil)
        }.to raise_error(TypeError)
      end
    end
    context "10_arrays" do
      let(:panel_provider){ FactoryBot.build(:panel_provider, '10_arrays')}
      let(:response_body){
        {
          testing1: [
            {test0: ['test01','test02','test03','test04','test05','test06','test07','test08','test09','test10','test11','test12']},
            {test1: ['test11','test12']},
            {test2: ['test21','test22','test23', 'test24']},
            {test3: ['test31','test32','test33', 'test34','test35']}
          ],
          testing2: 'testing002',
          testing3: 'testing003',
          testing4: 'testing004',
          testing5: 'testing005',
          testing6: ['testing601','testing602','testing603','testing604','testing605','testing606','testing607','testing608']
        }.to_json
      }
      it "should return correct price" do
        expect(panel_provider.send(:price_10_arrays, response_body, 2)).to eq 6
        expect(panel_provider.send(:price_10_arrays, response_body, 4)).to eq 5
        expect(panel_provider.send(:price_10_arrays, response_body, 6)).to eq 2
        expect(panel_provider.send(:price_10_arrays, response_body)).to eq 1
      end
      it "should raise error when response_body is not String" do
        expect{
          panel_provider.send(:price_times_html, nil)
        }.to raise_error(TypeError)
      end
    end
    context "times_html" do
      let(:panel_provider){ FactoryBot.build(:panel_provider, :times_html)}
      it "should return correct price" do
        response_body = '<nav><ul><li><a href="#nowhere" title="Lorum ipsum dolor sit amet">Lorem</a></li><li><a href="#nowhere" title="Aliquam tincidunt mauris eu risus">Aliquam</a></li><li><a href="#nowhere" title="Morbi in sem quis dui placerat ornare">Morbi</a></li><li><a href="#nowhere" title="Praesent dapibus, neque id cursus faucibus">Praesent</a></li><li><a href="#nowhere" title="Pellentesque fermentum dolor">Pellentesque</a></li></ul></nav>'
        expect(panel_provider.send(:price_times_html, response_body)).to eq 0.12
      end
      it "should return 0 when response_body doesn't have any a letters" do
        response_body = 'Lorem ipsum dolor sit Amet >> adfekfjidalksefji'
        expect(panel_provider.send(:price_times_html, response_body)).to eq 0
      end
      it "should raise error when response_body is not String" do
        expect{
          panel_provider.send(:price_times_html, nil)
        }.to raise_error(TypeError)
      end
    end
  end
end
