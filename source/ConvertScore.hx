class ConvertScore
{
	public static function convertScore(noteDiff:Float):Int
	{
		var daRating:String = Ratings.CalculateRating(noteDiff, 166);

		switch (daRating)
		{
			case 'shit':
				return 0;
			case 'bad':
				return 50;
			case 'good':
				return 100;
			case 'sick':
				return 300;
		}
		return 0;
	}
}
// changes: Changed values to reflect osu! scoring
// could add more cases but i think itll break the entire thing sooo
