import 'package:flutter/material.dart';

class PlanFeature {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;

  final bool isHighlighted;

  const PlanFeature({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    this.isHighlighted = false,
  });
}