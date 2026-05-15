import 'dart:io';

void main() {
  final file = File('c:/Users/Reem/Desktop/yusr/lib/features/be_leader/presentation/views/leader_map_tracking_view.dart');
  String content = file.readAsStringSync();

  // Add imports
  if (!content.contains('leader_map_top_card.dart')) {
    content = content.replaceFirst(
      'import \'package:yusr/features/return_to_compaign_location/presentation/widgets/tracking_fab_widget.dart\';',
      '''import 'package:yusr/features/return_to_compaign_location/presentation/widgets/tracking_fab_widget.dart';
import 'package:yusr/features/be_leader/presentation/widgets/leader_map_top_card.dart';
import 'package:yusr/features/be_leader/presentation/widgets/leader_map_legend.dart';
import 'package:yusr/features/be_leader/presentation/widgets/pilgrim_info_bottom_sheet.dart';'''
    );
  }

  // Replace _buildTopCard call
  content = content.replaceAll(
    '_buildTopCard(\n              context,\n              mapState.totalPilgrims,\n              mapState.leaderLocation != null && mapState.gpsWarning == null,\n              mapState,\n            )',
    'LeaderMapTopCard(\n              state: mapState,\n              isLeaderConnected: mapState.leaderLocation != null && mapState.gpsWarning == null,\n            )'
  );

  // Replace _buildLegend call
  content = content.replaceAll('_buildLegend()', 'const LeaderMapLegend()');

  // Replace _showPilgrimInfoSheet body with calling the bottom sheet widget
  // Wait, the showModalBottomSheet inside _showPilgrimInfoSheet can just use PilgrimInfoBottomSheet
  final showPilgrimInfoSheetRegex = RegExp(r'void _showPilgrimInfoSheet\(PilgrimMarkerData p, Color zoneColor\) \{.*?(?=  // ── البطاقة العلوية)', dotAll: true);
  
  content = content.replaceFirst(showPilgrimInfoSheetRegex, '''void _showPilgrimInfoSheet(PilgrimMarkerData p, Color zoneColor) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => PilgrimInfoBottomSheet(
        pilgrim: p,
        zoneColor: zoneColor,
      ),
    );
  }

''');

  // Remove the old methods _buildTopCard, _pilgrimCount, _buildLegend, _buildLegendItem, _infoRow
  final methodsToRemove = RegExp(r'  // ── البطاقة العلوية ───────────────────────────────────────────.*?(?=\}$)', dotAll: true);
  content = content.replaceFirst(methodsToRemove, '');

  file.writeAsStringSync(content);
}

