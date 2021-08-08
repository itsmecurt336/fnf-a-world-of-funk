import flixel.FlxG;

class Ratings
{
	public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
	{
		var ranking:String = "N/A";

		if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
			ranking = "(MFC)";
		else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "(GFC)";
		else if (PlayState.misses == 0) // Regular FC
			ranking = "(FC)";
		else if (PlayState.misses < 10) // Single Digit Combo Breaks
			ranking = "(SDCB)";
		else
			ranking = "(Clear)";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.99, // AAAAA
			accuracy >= 99.49, // AAAA:
			accuracy >= 99.24, // AAAA.
			accuracy >= 99, // AAAA
			accuracy >= 98, // AAA:
			accuracy >= 95, // AAA.
			accuracy >= 90, // AAA
			accuracy >= 85, // AA:
			accuracy >= 80, // AA.
			accuracy >= 75, // AA
			accuracy >= 70, // A:
			accuracy >= 65, // A.
			accuracy >= 60, // A
			accuracy >= 55, // B
			accuracy >= 50, // C
			accuracy < 50 // D
		];

		for (i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch (i)
				{
					case 0:
						ranking += " X";
					case 1:
						ranking += " U+";
					case 2:
						ranking += " U";
					case 3:
						ranking += " U-";
					case 4:
						ranking += " SS";
					case 5:
						ranking += " S+";
					case 6:
						ranking += " S";
					case 7:
						ranking += " S-";
					case 8:
						ranking += " A+";
					case 9:
						ranking += " A";
					case 10:
						ranking += " A-";
					case 11:
						ranking += " B+";
					case 12:
						ranking += " B";
					case 13:
						ranking += " B-";
					case 14:
						ranking += " C";
					case 15:
						ranking += " D";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}

	public static function CalculateRating(noteDiff:Float, ?customSafeZone:Float):String // Generate a judgement through some timing shit
	{
		var customTimeScale = Conductor.timeScale;

		if (customSafeZone != null)
			customTimeScale = customSafeZone / 166;

		// trace(customTimeScale + ' vs ' + Conductor.timeScale);

		// I HATE THIS IF CONDITION
		// IF LEMON SEES THIS I'M SORRY :(

		// trace('Hit Info\nDifference: ' + noteDiff + '\nZone: ' + Conductor.safeZoneOffset * 1.5 + "\nTS: " + customTimeScale + "\nLate: " + 155 * customTimeScale);

		if (FlxG.save.data.botplay && !PlayState.loadRep)
			return "sick"; // FUNNY

		var rating = checkRating(noteDiff, customTimeScale);

		return rating;
	}

	public static function checkRating(ms:Float, ts:Float)
	{
		var rating = "sick";
		if (ms <= 166 * ts && ms >= 135 * ts)
			rating = "shit";
		if (ms < 135 * ts && ms >= 115 * ts)
			rating = "bad";
		if (ms < 115 * ts && ms >= 76 * ts)
			rating = "good";
		if (ms < 76 * ts && ms >= 43 * ts)
			rating = "sick";
		if (ms < 43 * ts && ms >= 18 * ts)
			rating = "perf";
		if (ms < 18 * ts && ms >= -18 * ts)
			rating = "marv";
		if (ms < -43 * ts && ms >= -18 * ts)
			rating = "perf";
		if (ms < -76 * ts && ms >= -43 * ts)
			rating = "sick";
		if (ms > -115 * ts && ms <= -76 * ts)
			rating = "good";
		if (ms > -135 * ts && ms <= -115 * ts)
			rating = "bad";
		if (ms > -166 * ts && ms <= -135 * ts)
			rating = "shit";
		return rating;
	}

	public static function CalculateRanking(score:Int, scoreDef:Int, nps:Int, maxNPS:Int, accuracy:Float):String
	{
		return (FlxG.save.data.npsDisplay ? // NPS Toggle
			"NPS: "
			+ nps
			+ " (Max "
			+ maxNPS
			+ ")"
			+ (!PlayStateChangeables.botPlay || PlayState.loadRep ? " | " : "") : "") + // 	NPS
			(!PlayStateChangeables.botPlay
				|| PlayState.loadRep ? "Score:" + (Conductor.safeFrames != 10 ? score + " (" + scoreDef + ")" : "" + score) + // Score
					(FlxG.save.data.accuracyDisplay ? // Accuracy Toggle
						" | Combo Breaks:"
						+ PlayState.misses
						+ // 	Misses/Combo Breaks
						" | Accuracy:"
						+ (PlayStateChangeables.botPlay && !PlayState.loadRep ? "N/A" : HelperFunctions.truncateFloat(accuracy, 2) + " %")
						+ // 	Accuracy
						" | "
						+ GenerateLetterRank(accuracy) : "") : ""); // 	Letter Rank
	}
}
