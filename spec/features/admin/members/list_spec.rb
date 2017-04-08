RSpec.describe 'Members LIST' do
  let!(:user) { create(:user) }

  before do
    assume_admin_logged_in
  end

  it 'has member name' do
    visit '/admin'
    click_link('Members', match: :first)
    expect(page).to have_content user.full_name
  end

  describe 'filtering' do
    context 'when synthetic filter is turned on`' do
      it 'filters on synthetic users' do
        synthetic_user = create(:user, :synth)
        non_synthetic_user = create(:user, first_name: 'Denys')

        visit '/admin/members?filter_member[synthetic]=1'

        expect(page).to have_content synthetic_user.full_name
        expect(page).to_not have_content non_synthetic_user.full_name
      end
    end

    context 'when verified filter is turned on`' do
      it 'filters on verified users' do
        verified_user = create(:user, :verified)
        non_verified_user = create(:user, first_name: 'Denys', verified: false)

        visit '/admin/members?filter_member[verified]=1'

        expect(page).to have_content verified_user.full_name
        expect(page).to_not have_content non_verified_user.full_name
      end
    end

    context 'when verified and synthetic is turned on' do
      it 'filters on synthetic and verified users' do
        synthetic_user = create(:user, :synth, :verified)
        non_synthetic_user = create(:user, verified: false)

        visit '/admin/members?filter_member[synthetic]=1'

        expect(page).to have_content synthetic_user.full_name
        expect(page).to_not have_content non_synthetic_user.full_name
      end
    end

    context 'when speakers filter is turned on`' do
      it 'filters on speakers users' do
        speaker = create(:user)
        create(:talk, speaker: speaker)

        non_speaker = create(:user)

        visit '/admin/members?filter_member[speaker]=1'

        expect(page).to have_content speaker.full_name
        expect(page).to_not have_content non_speaker.full_name
      end
    end

    context 'when reset filters link is clicked' do
      it 'returns to the virgin state' do
        visit '/admin/members?filter_member[speaker]=0'

        click_link('Reset filters', match: :first)

        expect(page.current_path).to eq('/admin/members')
      end
    end
  end
end
