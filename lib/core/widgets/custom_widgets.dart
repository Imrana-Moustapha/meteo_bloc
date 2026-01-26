import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/core/themes/app_theme.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final Color? color;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: color ?? Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomLoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;

  const CustomLoadingWidget({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).primaryColor,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final bool showShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.color,
    this.borderRadius,
    this.onTap,
    this.showShadow = true,
  });

  // Méthode pour convertir BorderRadiusGeometry? en BorderRadius
  BorderRadius _toBorderRadius(BorderRadiusGeometry? borderRadius) {
    if (borderRadius == null) return BorderRadius.circular(12);
    
    // Si c'est déjà un BorderRadius, retournez-le
    // ignore: unnecessary_cast
    if (borderRadius is BorderRadius) return borderRadius as BorderRadius;
    
    // Sinon, essayez de convertir
    try {
      return borderRadius.resolve(TextDirection.ltr);
    } catch (e) {
      // En cas d'erreur, retournez la valeur par défaut
      return BorderRadius.circular(12);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = _toBorderRadius(borderRadius);

    return Card(
      margin: margin ?? const EdgeInsets.all(8),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: cardBorderRadius,
      ),
      elevation: showShadow ? 4 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: cardBorderRadius,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final buttonBorderRadius = borderRadius is BorderRadius
        ? borderRadius as BorderRadius
        : BorderRadius.circular(8);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: buttonBorderRadius,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class WeatherIconWidget extends StatelessWidget {
  final String iconCode;
  final double size;
  final bool isDay;

  const WeatherIconWidget({
    super.key,
    required this.iconCode,
    this.size = 64,
    this.isDay = true,
  });

  @override
  Widget build(BuildContext context) {
    final icon = iconCode.endsWith('n') && isDay
        ? iconCode.replaceFirst('n', 'd')
        : iconCode;

    return Image.network(
      'https://openweathermap.org/img/wn/$icon@2x.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          _getFallbackIcon(icon),
          size: size,
          color: AppTheme.getWeatherColor(_getConditionIdFromIcon(icon)),
        );
      },
    );
  }

  IconData _getFallbackIcon(String iconCode) {
    final iconMap = {
      '01': Icons.wb_sunny, // clear sky
      '02': Icons.wb_cloudy, // few clouds
      '03': Icons.cloud, // scattered clouds
      '04': Icons.cloud_queue, // broken clouds
      '09': Icons.grain, // shower rain
      '10': Icons.beach_access, // rain
      '11': Icons.flash_on, // thunderstorm
      '13': Icons.ac_unit, // snow
      '50': Icons.blur_on, // mist
    };

    final key = iconCode.substring(0, 2);
    return iconMap[key] ?? Icons.wb_sunny;
  }

  int _getConditionIdFromIcon(String iconCode) {
    final iconMap = {
      '01': 800, // clear sky
      '02': 801, // few clouds
      '03': 802, // scattered clouds
      '04': 804, // broken clouds
      '09': 300, // shower drizzle
      '10': 500, // rain
      '11': 200, // thunderstorm
      '13': 600, // snow
      '50': 701, // mist
    };

    final key = iconCode.substring(0, 2);
    return iconMap[key] ?? 800;
  }
}

class BlocConsumerWrapper<B extends StateStreamable<S>, S>
    extends StatelessWidget {
  final Widget Function(BuildContext, S) builder;
  final BlocWidgetListener<S>? listener;
  final B? bloc;
  final bool listenWhen;
  final bool buildWhen;

  const BlocConsumerWrapper({
    super.key,
    required this.builder,
    this.listener,
    this.bloc,
    this.listenWhen = true,
    this.buildWhen = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      bloc: bloc,
      listenWhen: (previous, current) => listenWhen,
      buildWhen: (previous, current) => buildWhen,
      listener: listener ?? (context, state) {},
      builder: builder,
    );
  }
}