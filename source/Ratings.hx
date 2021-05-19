import flixel.FlxG;

class Ratings
{
	public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
	{
		var ranking:String = "--";
		if (FlxG.save.data.botplay)
			ranking = "Auto";

		if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
			ranking = "(Marvelous Full Combo)";
		else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "(Good Full Combo)";
		else if (PlayState.misses == 0) // Regular FC
			ranking = "(Full Combo)";
		else if (PlayState.misses < 10) // Single Digit Combo Breaks
			ranking = "(Full Pass)";
		else
			ranking = "(Broken Combo)";

		// WIFE TIME :)))) (based on Wife3)
		// Changed the uhh names to fit (basis: osu!)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.99, // SS+
			accuracy >= 99.50, // SS:
			accuracy >= 99.25, // SS.
			accuracy >= 99.12, // SS
			accuracy >= 99, // S+:
			accuracy >= 98, // S+.
			accuracy >= 97, // S+
			accuracy >= 96, // S:
			accuracy >= 95, // S.
			accuracy >= 93, // S
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy < 60 // D
		];

		for (i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch (i)
				{
					case 0:
						ranking += " SS+";
					case 1:
						ranking += " SS:";
					case 2:
						ranking += " SS.";
					case 3:
						ranking += " SS";
					case 4:
						ranking += " S+:";
					case 5:
						ranking += " S+.";
					case 6:
						ranking += " S+";
					case 7:
						ranking += " S:";
					case 8:
						ranking += " S.";
					case 9:
						ranking += " S";
					case 10:
						ranking += " A:";
					case 11:
						ranking += " A.";
					case 12:
						ranking += " A";
					case 13:
						ranking += " B";
					case 14:
						ranking += " C";
					case 15:
						ranking += " D";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "--";
		else if (FlxG.save.data.botplay)
			ranking = "Auto";

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

		if (FlxG.save.data.botplay)
			return "good"; // BOT GOOD HOWOWWOOANFSAKNFKJWAR

		if (noteDiff > 166 * customTimeScale) // so god damn early its a miss
			return "miss";
		if (noteDiff > 135 * customTimeScale) // way early
			return "shit";
		else if (noteDiff > 90 * customTimeScale) // early
			return "bad";
		else if (noteDiff > 45 * customTimeScale) // your kinda there
			return "good";
		else if (noteDiff < -45 * customTimeScale) // little late
			return "good";
		else if (noteDiff < -90 * customTimeScale) // late
			return "bad";
		else if (noteDiff < -135 * customTimeScale) // late as fuck
			return "shit";
		else if (noteDiff < -166 * customTimeScale) // so god damn late its a miss
			return "miss";
		return "sick";
	}

	public static function CalculateRanking(score:Int, scoreDef:Int, nps:Int, maxNPS:Int, accuracy:Float):String
	{
		return (FlxG.save.data.npsDisplay ? "NPS: " + nps + " (Max " + maxNPS + ")" + (!FlxG.save.data.botplay ? " | " : "") : "")
			+ (!FlxG.save.data.botplay ? // NPS Toggle
				"Score:"
				+ (Conductor.safeFrames != 10 ? score + " (" + scoreDef + ")" : "" + score)
				+ // Score
				" | Misses:"
				+ PlayState.misses
				+ // Misses/Combo Breaks
				" | Accuracy:"
				+ (FlxG.save.data.botplay ? "N/A" : HelperFunctions.truncateFloat(accuracy, 2) + " %")
				+ // Accuracy
				" | "
				+ GenerateLetterRank(accuracy) : ""); // Letter Rank
	}
}
