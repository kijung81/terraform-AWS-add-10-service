resource "aws_lb" "alb" {
  name               = "10-svc-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_subnet.pub_sbn_a.id, aws_subnet.pub_sbn_b.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.prefix}-svc-alb"
  }
}

resource "aws_lb_listener" "alb_lst" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }  
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "09-check-albtg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.example.id

  health_check {
    port                = 80
    protocol            = "HTTP"
    unhealthy_threshold = 10
    healthy_threshold   = 10
  }  
}

resource "aws_lb_target_group_attachment" "web1" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web2" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}