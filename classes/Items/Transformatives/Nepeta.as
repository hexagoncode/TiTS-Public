package classes.Items.Transformatives 
{
	import classes.BreastRowClass;
	import classes.CockClass;
	import classes.Creature;
	import classes.ItemSlotClass;
	import classes.GLOBAL;
	import classes.GameData.TooltipManager;
	import classes.StringUtil;
	import classes.VaginaClass;
	
	import classes.Engine.Utility.rand;
	import classes.Engine.Utility.num2Text;
	import classes.Engine.Utility.indefiniteArticle;
	import classes.Util.RandomInCollection;
	
	import classes.Engine.Interfaces.*;
	
	import classes.kGAMECLASS;
	
	/**
	 * ...
	 * @author Gedan
	 */
	public class Nepeta extends ItemSlotClass
	{
		
		public function Nepeta() 
		{
			this._latestVersion = 1;
			
			this.quantity = 1;
			this.stackSize = 10;
			this.type = GLOBAL.PILL;
			
			this.shortName = "nepeta";
			this.longName = "Nepeta";
			
			TooltipManager.addFullName(this.shortName, StringUtil.toTitleCase(this.longName));
			
			this.description = "a small baggie of nepeta treats";
			
			this.tooltip = "These small bags of drugged-up treats were produced by Xenogen shortly after first contact with the cat-like kaithrit. When eaten, the treats release a potent cocktail of transformative nanomachines to re-work your body into a pleasingly feminine, feline form.";
			
			TooltipManager.addTooltip(this.shortName, this.tooltip);
			
			this.basePrice = 500;
			
			this.version = this._latestVersion;
		}
		
		override public function useFunction(target:Creature, usingCreature:Creature = null):Boolean
		{
			var changeLimit:int = 1 + rand(3);
			var eaten:int = 0;
			var changes:int = 0;
			
			clearOutput();
			output("You up-end a baggie filled with a handful of the nepeta treats into the palm of your [pc.hand]. To some level of mild amusement you count " + num2Text(changeLimit) + " cute little cat-face shaped treats mixed in amongst some crumbly remnants of more complete foodstuffs.");

			var nomText:Array = [];
			nomText.push("Wasting no more time, you pick out one of the cutesy biscuits and nibble down on the edge. Pleased with the taste, you make quick work of it.");
			nomText.push("The first treat polished off in short order, you reach for another and quickly bite into the crunchy treat.");
			nomText.push("With only one whole biscuit left cupped in your palm, you greedily scoop it into your mouth -- a little rain of crumbs falling from your face as you bite into the final treat.");

			var tfs:Array;
			var lastExec:Function;
			
			while (eaten < changeLimit)
			{
				output(nomText[changes]);
				output("\n\n");

				tfs = [];
				
				if (target.earType != GLOBAL.TYPE_FELINE && target.earTypeUnlocked(GLOBAL.TYPE_FELINE)) tfs.push(earTF);
				if (target.eyeType != GLOBAL.TYPE_FELINE && target.eyeTypeUnlocked(GLOBAL.TYPE_FELINE)) tfs.push(eyeTF);
				if (target.skinType != GLOBAL.SKIN_TYPE_SKIN && target.skinTypeUnlocked(GLOBAL.SKIN_TYPE_SKIN)) tfs.push(skinTF);
				if ((target.tailCount != 2 && target.tailCountUnlocked(2)) || (target.tailType != GLOBAL.TYPE_FELINE && target.tailTypeUnlocked(GLOBAL.TYPE_FELINE))) tfs.push(tailTF);
				if ((target.legCount != 2 && target.legCountUnlocked(2)) || !target.hasLegFlag(GLOBAL.FLAG_PLANTIGRADE) || (target.legType != GLOBAL.TYPE_FELINE && target.legTypeUnlocked(GLOBAL.TYPE_FELINE))) tfs.push(legTF);
				if ((target.faceType != GLOBAL.TYPE_HUMAN && target.faceTypeUnlocked(GLOBAL.TYPE_HUMAN)) || target.hasFaceFlag(GLOBAL.FLAG_MUZZLED)) tfs.push(faceTF);
				
				if (target.femininity < 75 && target.femininityUnlocked(75)) tfs.push(femTF);
				
				if (target.hasCock())
				{
					for (var ci:int = 0; ci < target.cocks.length; ci++)
					{
						if ((target.cocks[ci] as CockClass).cType != GLOBAL.TYPE_FELINE && target.cockTypeUnlocked(ci, GLOBAL.TYPE_FELINE))
						{
							if (tfs.indexOf(cockTF) == -1) tfs.push(cockTF);
						}
						if ((target.cocks[ci] as CockClass).cLengthRaw > 4 && target.cockLengthUnlocked(ci, 4))
						{
							if (tfs.indexOf(cockShrinkTF) == -1) tfs.push(cockShrinkTF);
						}
					}
					
					if ((target.breastRows[0] as BreastRowClass).breastRatingRaw < 1 && target.breastRatingUnlocked(0, 1))
					{
						tfs.push(breastTF);
					}
				}
				else
				{
					if ((target.breastRows[0] as BreastRowClass).breastRatingRaw < 9 && target.breastRatingUnlocked(0, 9))
					{
						tfs.push(breastTF);
					}
				}
				
				for (var bi:int = 0; bi < target.breastRows.length; bi++)
				{
					if (target.breastRows[bi].nippleType != GLOBAL.NIPPLE_TYPE_NORMAL && target.nippleTypeUnlocked(bi, GLOBAL.NIPPLE_TYPE_NORMAL)) tfs.push(nipTF);
				}
				
				if (target.hasCock() && !target.hasVagina())
				{
					if (target.tallness < 60 && target.tallnessUnlocked(60)) tfs.push(heightTF);
					if (target.tallness > 74 && target.tallnessUnlocked(74)) tfs.push(heightTF);
				}
				else
				{
					if (target.tallness < 66 && target.tallnessUnlocked(66)) tfs.push(heightTF);
					if (target.tallness > 87 && target.tallnessUnlocked(87)) tfs.push(heightTF);
				}
				
				if (tfs.length > 0)
				{
					var selectedTF:Function = RandomInCollection(tfs);
					selectedTF(target);
					output("\n\n");
					changes++;
				}
				eaten++;
			}

			if (changes == 0)
			{
				output("\n\nAs tasty as the sweet little treats are, you were expecting a little more considering the cost -- after all, if you'd just wanted a snack to satisfy your sweet tooth, you wouldn't have been eating a much more expensive nanomachine-doped product.");
			}
			
			return false;
		}
		
		private function earTF(target:Creature):void
		{
			//Gain feline ears.
			output("Your [pc.ears] start to burn, forcing you to stop and rub at them.");
			// 9999
			// " {if not top-placed ears: As you run your fingers across them, your ears begin to quiver and... move... altering their place on your head until they're perched near the top of your head.}");
			output(" They begin to change shape, growing pointed and sprouting a thin layer of fuzz. Before long, you realize <b>you've grown a pair of feline ears!</b>. Meow!");
			target.earType = GLOBAL.TYPE_FELINE;
		}
		
		private function eyeTF(target:Creature):void
		{
			//Gain cat eyes
			output("Your [pc.eyes] start to water, and no matter how much you blink, your vision just grows fuzzier and fuzzier for several moments before seeming to clear all of a sudden. You pull your Codex out and check your reflection: <b>a pair of [pc.eyeColor] cat-eyes stare back at you</b>, slitted and brilliantly-bright!");

			target.eyeType = GLOBAL.TYPE_FELINE;
		}
		
		private function skinTF(target:Creature):void
		{
			//Gain normal human skin, full body. Lose fur/scales/whatever.
			output("An itch begins to spread across your body, making you pause and start to rub and scratch yourself all over.");
			if (target.skinType == GLOBAL.SKIN_TYPE_FUR) output(" Your body's furry covering starts to fall off, giving way to the growing spread of [pc.skinColor] skin underneath.");
			else if (target.skinType == GLOBAL.SKIN_TYPE_SCALES) output(" Your abrasive, scaley covering starts to fall away, making way for spreading blotches of [pc.skinColor] skin beneath.");
			else if (target.skinType == GLOBAL.SKIN_TYPE_GOO) output(" Your gooey body begins to solidify, wracking you with strange sensations. Slowly but surely, your goo is replaced with skin, and your internals solidify into something more normal for the kaithrit you're striving to become! Before long, your body is covered with solid flesh!");
			output(" <b>You have normal, humanoid skin now!</b>");

			target.skinType = GLOBAL.SKIN_TYPE_SKIN;
		}
		
		private function tailTF(target:Creature):void
		{
			//Gain a cat tail. If you already have a cat tail, gain a second one!
			if (target.tailCount == 0)
			{
				output("You feel a mounting pressure on your backside, culminating in what feels like a knot forming just over your [pc.butt]. You give a yelp as the knot bursts, and suddenly flesh is spilling out behind you, forming into a slender tendril. After a moment of combined panic and ecstasy, you realize the squirming mass of flesh is coalescing into a tail. It starts to sprout a thin layer of fur, a fuzzy coating");
				if (target.hairLength > 0) output(" that matches the color of your [pc.hair]");
				output(". You give it a little flex, and find that it curls about your [pc.leg] with prehensile grace. Yep, <b>you've definitely got a cat's tail now.</b>");

				target.tailCount = 1;
				target.tailType = GLOBAL.TYPE_FELINE;
				target.tailFlags = [GLOBAL.FLAG_LONG, GLOBAL.FLAG_FURRED];
			}
			else if (target.tailType != GLOBAL.TYPE_FELINE)
			{
				output("Your tail");
				if (target.tailCount == 1) output(" is");
				else output("s are");
				output(" wracked with a strange pleasure,");
				if (target.tailCount == 1) output(" and starts to");
				else output(" and start to");
				if (target.hasTailFlag(GLOBAL.FLAG_SCALED))
				{
					if (target.tailCount == 1) output(" molt its scales");
					else output(" molt their scales");
				}
				else if (target.hasTailFlag(GLOBAL.FLAG_FLUFFY))
				{
					if (target.tailCount == 1) output(" lose some of its bushy fur");
					else output(" lose some of their bushy fur");
				}
				else
				{
					output(" mutate");
				}

				if (target.tailCount > 2)
				{
					output(". The sensation starts to fade away much faster in");
					if (target.tailCount == 3) output(" one")
					else output(" a number");
					output(" of your tails, the lively and unconcious movement calming in concert with the feeling. With a curiously sharp pull, one of your tails falls away to the ground leaving you one shorter than you started off.");
					if (target.tailCount > 3) output(" Another pull, and another tail falls away....");
					if (target.tailCount > 4) output(" And again....");
					output("\n\nWith only two tails left, their uncontrolled movement kicks back into high-gear");
					target.tailCount = 2;
				}

				output(". You watch as");
				if (target.tailCount == 1) output(" it becomes");
				else output(" they become");
				output(" small, slender, and the muscles within");
				if (target.tailCount == 1) output(" it");
				else output(" them");
				output(" contract, causing");
				if (target.tailCount == 1) output(" it");
				else output(" them");
				output(" to curl around your [pc.leg]. With a flick, you find that");
				if (target.tailCount == 1) output(" it moves");
				else output(" they move");
				output(" with prehensile grace.");
				if (target.tailCount == 1) output(" <b>Your tail's just like a cat's now!</b>");
				else output(" <b>Your tails are just like a cat's now!</b>");

				target.tailType = GLOBAL.TYPE_FELINE;
				target.tailFlags = [GLOBAL.FLAG_LONG, GLOBAL.FLAG_FURRED];
			}
			else if (target.tailCount == 1 && target.tailType == GLOBAL.TYPE_FELINE)
			{
				output("You feel a gentle tug beside your feline tail, swelling into a knot of flesh. You have just enough time to");
				if (!target.isNude()) output(" pull your [pc.gear] off");
				else output(" look over your shoulder");
				output(" before the knot erupts into a rapidly-growing tendril of flesh and muscle. After a moment of combined panic and ecstasy, you realize the squirming mass of flesh is coalescing into a tail. It starts to sprout a thin layer of fur, a fuzzy coating");
				if (target.hairLength > 0) output(" that matches the color of your [pc.hair]");
				output(". You give it a little flex, and find that it curls playfully around your existing kitty-tail: <b>you've got two cat-tails now!</b>");

				target.tailCount = 2;
			}
		}
		
		private function legTF(target:Creature):void
		{
			//Gain human legs, bipedalism
			if (target.isTaur())
			{
				output("Your bestial lower body begins to change, spurred on by the sweet Nepeta treats. You feel your body contracting, crunching down and compacting. You feel your bones and organs changing place, steadily mutating until it no longer resembles the body of a beast, but a human. With wide eyes, you watch yourself slink down from your previous height, no longer resting atop your lower body but forced to stand on wobbly legs -- strikingly human legs, at that. Your additional legs are absorbed, drawing into your vanishing lower body until <b>you have a humanoid figure</b>, complete with two arms and two legs.");
			}
			else if (target.isTaur())
			{
				output("Your serpentine coils are suddenly torn by convulsions... and begin to split apart. You stumble and collapse as your lower body fails you, throwing you on your ass and down on the ground. With a wet, tearing sound, your lower body cracks in half and starts to reshape itself into a pair of blatantly humanoid legs. After a few awkward minutes, your body seems to finalize into its new form, and you scrabble up onto your new-found legs. You stumble around on them for a few moments, trying to get your balance right. <b>Your new human legs</b> are perfectly smooth, covered with [pc.skinColor]. Very nice!");
			}
			else
			{
				output("Your inhuman legs begin to change in form,");
				if (target.hasLegFlag(GLOBAL.FLAG_FURRED)) output(" losing their fur and");
				else if (target.hasLegFlag(GLOBAL.FLAG_SCALED)) output(" losing their scales and");
				else if (target.hasLegFlag(GLOBAL.FLAG_CHITINOUS)) output(" losing their covering and");
				output(" changing in shape");
				output(" until <b>they look smooth and human</b>. You slowly wander around, adjusting to the new feeling in your legs. Not bad!");
			}

			target.legCount = 2;
			target.legType = GLOBAL.TYPE_HUMAN;
			target.legFlags = [GLOBAL.FLAG_PLANTIGRADE];
		}
		
		private function faceTF(target:Creature):void
		{
			//PC doesn't have a human face. Gain a human face.
			output("You feel your [pc.face] start to strain, becoming");
			if (target.faceType == GLOBAL.TYPE_GOOEY || target.skinType == GLOBAL.SKIN_TYPE_GOO) output(" harder and firmer, taking on a more defined shape");
			else output(" softer and more malleable");
			output(". You run a hand along your mutating features, and find that your face is taking on an altogether more human shape. You're soon left with a solidifying visage:");
			if (target.isMasculine()) output(" you've got a manly jaw and sharp features,");
			else output(" you have a cute little nose and delicate features,");
			output(" <b>an altogether human face</b>.");

			target.faceType = GLOBAL.TYPE_HUMAN;
			target.faceFlags = [];
		}
		
		private function femTF(target:Creature):void
		{
			//Gain femininity, regardless of gender/sex.
			output("You feel a subtle shift in your facial features, a raise of your cheekbones and a turn in your nose. You pull your Codex out and examine yourself in the reflection of its screen: you look a hell of a lot cuter now, much more feminine. You find yourself pursing your lips and admiring yourself, tracing a finger along your more delicate features. <b>You feel much more feminine now</b>.");

			target.femininity += 5;
			if (target.femininity > 75) target.femininity = 75;
		}
		
		private function breastTF(target:Creature):void
		{
			//Get titties. If PC has only a dick, go up to A-cups. If has cunt, up to EE cups. No shrinkage.
			if (target.breastRows[0].breastRatingRaw < 1)
			{
				output("You feel a tingling spread across your [pc.chest], drawing an exploratory touch along your [pc.skin]. You feel small bumps rising on your chest, slowly filling in with delightfully soft fat that makes them perfect to cup your hands around and gently caress. After they finish growing in, you take a moment to analyze your new chest balloons: they measure up to");
				if (target.hasCock() && !target.hasVagina())
				{
					target.breastRows[0].breastRatingRaw = 1;
					output(" mere A-cups");
				}
				else
				{
					target.breastRows[0].breastRatingRaw = 2;
					output(" perky little B-cups");
				}
				output(".");
			}
			else if (target.breastRows[0].breastRatingRaw < 3)
			{
				output("You feel a bit of a straining in your [pc.boobs] -- you quickly realize they're growing again! You enjoy the sensation, cupping your burgeoning bosom as it fills out with growing weight. They're sensitive to the touch, sending shockwaves of pleasure through you. Especially your [pc.nipples], which you take a great deal of pleasure in teasing and pinching. Eventually, once your tits have nicely filled out into bouncy little handfuls,");

				var bGain:Number = 7 - target.breastRows[0].breastRatingRaw;
				bGain = 1 + rand(bGain / 2);
				target.breastRows[0].breastRatingRaw += bGain;

				output(" <b>you reckon you're up to "+indefiniteArticle(target.breastCup(0))+"!</b> You readjust your gear to conform to your new, more buxom physique.");
			}
			else
			{
				bGain = 7 - target.breastRows[0].breastRatingRaw;
				bGain = 1 + rand(bGain / 2);
				target.breastRows[0].breastRatingRaw += bGain;

				output("Your boobs quake with pleasure, starting to expand at the behest of the Nepeta. You're really becoming the busty cat-babe you always wanted to be now! Smiling to yourself, you play with your growing bust as it fills out more and more, <b>eventually pumping up to a hefty, pillowy "+target.breastCup(0)+"!</b>.");
			}
		}
		
		private function nipTF(target:Creature):void
		{
			//Normal human nips.
			output("You feel your [pc.nipples] start to change, shifting in size and shape ever so slightly. You push your [pc.gear] out of the way to get a look, just in time to see your teats transitioning into what look like <b>perfectly normal, pink human nipples.</b> You give them a tease, and find that they're delightfully sensitive to the touch. It's all you can do to stop yourself from just breaking down and playing with them....\n\nMaybe later.");

			for (var bi:int = 0; bi < target.breastRows.length; bi++)
			{
				(target.breastRows[bi] as BreastRowClass).nippleType = GLOBAL.NIPPLE_TYPE_NORMAL;
			}
			target.nipplesPerBreast = 1;
		}
		
		private function heightTF(target:Creature):void
		{
			var isShrink:Boolean = false;

			//Males shrink to 6' 2” or grow to 5'.
			if (target.hasCock() && !target.hasVagina())
			{
				if (target.tallness < 60)
				{
					target.tallness += 6;
				}
				else
				{
					target.tallness -= 6;
					isShrink = true;
				}
			}
			else
			{
				if (target.tallness < 66)
				{
					target.tallness += 6;
				}
				else
				{
					target.tallness -= 6;
					isShrink = true;
				}
			}

			if (!isShrink)
			{
				output("You feel your center of gravity seem to shift, making you stumble around. Your limbs and torso stretch out, growing and growing to the beat of the Nepeta pounding through your veins. You feel taller, faster, stronger after the drug's done its work. A quick glance at your Codex's monitor program tells you that <b>you're "+target.shortHeight()+" now!</b>");
			}
			else
			{
				output("Your entire world starts to spin and swim, and you find yourself slipping closer to the ground. At first you think you're falling, but then you realize your [pc.legs] are firmly planted on the ground. You're shrinking! After a moment, you catch your balance and try and adjust to your reduced height. A quick glance at your Codex's monitor program tells you that <b>you're "+target.shortHeight()+" now!</b> While you're going to miss your impressive vantage over the rest of the world, at least you're more kaithrit now!");
			}
		}
		
		private function cockShrinkTF(target:Creature):void
		{
			//Rarest reaction. Reduce cocksize. 2-4 inches per.

			for (var ci:int = 0; ci < target.cocks.length; ci++)
			{
				if (target.cockLengthUnlocked(ci, 4) && target.cocks[ci].cLengthRaw > 4)
				{
					target.cocks[ci].cLengthRaw -= (2 + rand(3));
					if (target.cocks[ci].cLengthRaw < 4) target.cocks[ci].cLengthRaw = 4;
				}
			}

			output("You feel a strange, contracting sensation in your [pc.cocks]. While not altogether unpleasant, you're not sure you could really call it pleasure either. You reach a hand down to inspect your member");
			if (target.cocks.length > 1) output("s");
			output(", and instantly realize");
			if (target.cocks.length == 1) output(" it seems");
			else output(" they seem")
			output(" smaller than before. Moaning softly, you gently massage your diminishing length");
			if (target.cocks.length > 1) output("s");
			output(" as the Nepeta treat does its work, making you more and more like the small, feminine males of the kaithrit race. When all's said and done, <b>you figure you've lost a good few inches -- your cock");
			if (target.cocks.length == 1) output(" is");
			else output("s are");
			output(" definitely smaller than you used to be.</b>");
		}
		
		private function cockTF(target:Creature):void
		{
			//Gain feline nubs on your dick. Must already have cock.

			for (var ci:int = 0; ci < target.cocks.length; ci++)
			{
				if (target.cocks[ci].cType != GLOBAL.TYPE_FELINE && target.cockTypeUnlocked(ci, GLOBAL.TYPE_FELINE))
				{
					target.cocks[ci].cType = GLOBAL.TYPE_FELINE;
					target.cocks[ci].flags = [GLOBAL.FLAG_NUBBY];
				}
			}

			output("Your [pc.cocks] start");
			if (target.cocks.length == 1) output("s");
			output(" to throb and harden, burning with mounting arousal. You feel something swelling near your cockhead");
			if (target.cocks.length > 1) output("s");
			output(" more than just the normal turgidity of erection... and your flesh seems to be bubbling up, becoming covered with small nodules. You");
			if (target.isCrotchGarbed()) output(" slip a hand into your clothes and");
			output(" feel up");
			if (target.cocks.length > 1) output(" one of");
			output(" your stiff shaft");
			if (target.cocks.length > 1) output("s");
			output(", running a hand along your length. <b>It looks like you have feline nubs on your cock");
			if (target.cocks.length > 1) output("s");
			output(" now!</b>");
		}
	}

}