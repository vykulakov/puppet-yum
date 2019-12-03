require 'spec_helper'

describe 'yum::versionlock' do
  let(:facts) { { os: { release: { major: 7 } } } }

  context 'with a simple, well-formed title' do
    let(:title) { '0:bash-4.1.2-9.el6_2.x86_64' }

    context 'and no parameters' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_exec('yum-versionlock-clear').with_command('/usr/bin/yum versionlock clear') }
      it 'contains a well-formed versionlock call' do
        is_expected.to contain_exec("yum-versionlock-#{title}").with_command("/usr/bin/yum versionlock add #{title}")
      end
    end
    context 'clean set to true on module' do
      let :pre_condition do
        'class { "yum::plugin::versionlock": clean => true, }'
      end

      it { is_expected.to contain_exec('yum-versionlock-clear').with_command('/usr/bin/yum versionlock clear') }
      it { is_expected.to contain_exec('yum-versionlock-clear').with_notify('Exec[yum_clean_all]') }
      it { is_expected.to contain_exec('yum_clean_all').with_command('/usr/bin/yum clean all') }
    end
    context 'remove locks set to false on module' do
      let :pre_condition do
        'class { "yum::plugin::versionlock": clean => true, remove_locks => false }'
      end

      it { is_expected.not_to contain_exec('yum-versionlock-clear') }
      it { is_expected.to contain_exec('yum_clean_all').with_command('/usr/bin/yum clean all') }
    end
    context 'and ensure set to present' do
      let(:params) { { ensure: 'present' } }

      it { is_expected.to compile.with_all_deps }
      it 'contains a well-formed versionlock call' do
        is_expected.to contain_exec("yum-versionlock-#{title}").with_command("/usr/bin/yum versionlock add #{title}")
      end
    end

    context 'and ensure set to exclude' do
      let(:params) { { ensure: 'exclude' } }

      it { is_expected.to compile.with_all_deps }
      it 'contains a well-formed versionlock call' do
        is_expected.to contain_exec("yum-versionlock-#{title}").with_command("/usr/bin/yum versionlock exclude #{title}")
      end
    end

    context 'and ensure set to absent' do
      let(:params) { { ensure: 'absent' } }

      it { is_expected.to compile.with_all_deps }
      it 'contains a well-formed versionlock call' do
        is_expected.to contain_exec("yum-versionlock-#{title}").with_command("/usr/bin/yum versionlock delete #{title}")
      end
    end
  end
end
