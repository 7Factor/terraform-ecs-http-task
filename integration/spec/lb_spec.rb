require 'awspec'
require 'hcl/checker'

TFVARS = HCL::Checker.parse(File.open('testing.tfvars').read())
TFOUTPUTS  = eval(ENV['KITCHEN_KITCHEN_TERRAFORM_OUTPUTS'])

describe alb(TFOUTPUTS[:lb_name][:value]) do
  it { should exist }
  it { should be_active }
  it { should have_security_group(TFVARS['cluster_lb_sg_id']) }
  it { should have_subnet(TFVARS['lb_public_subnets'][0]) }
  it { should have_subnet(TFVARS['lb_public_subnets'][1]) }
  it { should have_tag('Name').value("Application LB #{TFVARS['app_name']}") }
  it { should belong_to_vpc(TFVARS['vpc_id']) }
end

describe alb_listener(TFOUTPUTS[:lb_secure_listener][:value]) do
  it { should exist }
  its(:port) { should eq 443 }
  its(:protocol) { should eq 'HTTPS' }
  its(:load_balancer_arn) { should eq TFOUTPUTS[:lb_arn][:value]}

  it 'should have the correct certs' do
    certificates = subject.certificates.map {|certificate| certificate}

    expect(certificates.first.certificate_arn).to eq TFVARS['lb_cert_arn']
  end
end

describe alb_target_group(TFOUTPUTS[:lb_target_group_name][:value]) do
  it { should exist }
  its(:health_check_interval_seconds) { should eq TFVARS['health_check_interval'] }
  its(:health_check_path) { should eq TFVARS['health_check_path'] }
  its(:health_check_port) { should eq TFVARS['health_check_port'] }
  its(:health_check_protocol) { should eq TFVARS['health_check_protocol'] }
  its(:health_check_timeout_seconds) { should eq TFVARS['health_check_timeout'] }
  its(:healthy_threshold_count) { should eq TFVARS['health_check_threshold'] }
  its(:unhealthy_threshold_count) { should eq TFVARS['health_check_unhealthy_threshold']}
  its(:vpc_id) { should eq TFVARS['vpc_id']}

  it 'should have the correct load balancers' do
    load_balancer_arns = subject.load_balancer_arns.map {|load_balancer_arn| load_balancer_arn}

    expect(load_balancer_arns.first).to eq TFOUTPUTS[:lb_arn][:value]
  end
end