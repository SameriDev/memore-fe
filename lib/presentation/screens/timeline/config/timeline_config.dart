class ResponsiveConfig {
  final double circleSize;
  final double circleDaySize;
  final double circleMonthSize;
  final double itemMargin;
  final double itemSpacing;
  final double contentPadding;
  final double itemHeight;
  final int imageFlex;
  final int textFlex;
  final double headerPadding;
  final double headerTitleSize;
  final double headerSubtitleSize;
  final double headerIconSize;
  final double dateIndicatorDaySize;
  final double dateIndicatorMonthSize;
  final double itemTopPadding;
  final double titleSize;
  final double subtitleSize;
  final double timeSize;
  final bool useVerticalLayout;

  const ResponsiveConfig({
    required this.circleSize,
    required this.circleDaySize,
    required this.circleMonthSize,
    required this.itemMargin,
    required this.itemSpacing,
    required this.contentPadding,
    required this.itemHeight,
    required this.imageFlex,
    required this.textFlex,
    required this.headerPadding,
    required this.headerTitleSize,
    required this.headerSubtitleSize,
    required this.headerIconSize,
    required this.dateIndicatorDaySize,
    required this.dateIndicatorMonthSize,
    required this.itemTopPadding,
    required this.titleSize,
    required this.subtitleSize,
    required this.timeSize,
    required this.useVerticalLayout,
  });

  factory ResponsiveConfig.fromWidth(double width) {
    if (width < 360) {
      return const ResponsiveConfig(
        circleSize: 50,
        circleDaySize: 12,
        circleMonthSize: 8,
        itemMargin: 20,
        itemSpacing: 30,
        contentPadding: 12,
        itemHeight: 200,
        imageFlex: 3,
        textFlex: 5,
        headerPadding: 16,
        headerTitleSize: 24,
        headerSubtitleSize: 12,
        headerIconSize: 40,
        dateIndicatorDaySize: 24,
        dateIndicatorMonthSize: 12,
        itemTopPadding: 30,
        titleSize: 15,
        subtitleSize: 11,
        timeSize: 9,
        useVerticalLayout: true,
      );
    } else if (width < 600) {
      return const ResponsiveConfig(
        circleSize: 60,
        circleDaySize: 13,
        circleMonthSize: 9,
        itemMargin: 30,
        itemSpacing: 40,
        contentPadding: 16,
        itemHeight: 180,
        imageFlex: 3,
        textFlex: 5,
        headerPadding: 20,
        headerTitleSize: 26,
        headerSubtitleSize: 13,
        headerIconSize: 44,
        dateIndicatorDaySize: 26,
        dateIndicatorMonthSize: 13,
        itemTopPadding: 35,
        titleSize: 16,
        subtitleSize: 12,
        timeSize: 10,
        useVerticalLayout: false,
      );
    } else {
      return const ResponsiveConfig(
        circleSize: 70,
        circleDaySize: 15,
        circleMonthSize: 10,
        itemMargin: 50,
        itemSpacing: 50,
        contentPadding: 16,
        itemHeight: 180,
        imageFlex: 3,
        textFlex: 5,
        headerPadding: 24,
        headerTitleSize: 28,
        headerSubtitleSize: 14,
        headerIconSize: 48,
        dateIndicatorDaySize: 28,
        dateIndicatorMonthSize: 14,
        itemTopPadding: 40,
        titleSize: 18,
        subtitleSize: 13,
        timeSize: 11,
        useVerticalLayout: false,
      );
    }
  }
}
