<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- this vocabulary was first used for the Shahid poetry files. 
The CV itself comes from http://www.loc.gov/rr/mopic/miggen.html -->
    
    <xsl:variable name="dhimigfigGenre">
        <xsl:text>Actuality</xsl:text>
        <xsl:text>Adaptation</xsl:text>
        <xsl:text>Adventure</xsl:text>
        <xsl:text>Adventure (Nonfiction)</xsl:text>
        <xsl:text>Ancient world</xsl:text>
        <xsl:text>Animal</xsl:text>
        <xsl:text>Art</xsl:text>
        <xsl:text>Aviation</xsl:text>
        <xsl:text>Biographical</xsl:text>
        <xsl:text>Biographical (Nonfiction)</xsl:text>
        <xsl:text>Buddy</xsl:text>
        <xsl:text>Caper</xsl:text>
        <xsl:text>Chase</xsl:text>
        <xsl:text>Children's</xsl:text>
        <xsl:text>College</xsl:text>
        <xsl:text>Comedy</xsl:text>
        <xsl:text>Crime</xsl:text>
        <xsl:text>Dance</xsl:text>
        <xsl:text>Dark comedy</xsl:text>
        <xsl:text>Disability</xsl:text>
        <xsl:text>Disaster</xsl:text>
        <xsl:text>Documentary</xsl:text>
        <xsl:text>Domestic comedy</xsl:text>
        <xsl:text>Educational</xsl:text>
        <xsl:text>Erotic</xsl:text>
        <xsl:text>Espionage</xsl:text>
        <xsl:text>Ethnic</xsl:text>
        <xsl:text>Ethnic (Nonfiction)</xsl:text>
        <xsl:text>Ethnographic</xsl:text>
        <xsl:text>Experimental (for subdivisions below, see Appendix A)</xsl:text>
        <xsl:text>Absolute</xsl:text>
        <xsl:text>Abstract live action</xsl:text>
        <xsl:text>Activist</xsl:text>
        <xsl:text>Autobiographical</xsl:text>
        <xsl:text>City symphony</xsl:text>
        <xsl:text>Cubist</xsl:text>
        <xsl:text>Dada</xsl:text>
        <xsl:text>Diary</xsl:text>
        <xsl:text>Feminist</xsl:text>
        <xsl:text>Gay/lesbian</xsl:text>
        <xsl:text>Intermittent animation</xsl:text>
        <xsl:text>Landscape</xsl:text>
        <xsl:text>Loop</xsl:text>
        <xsl:text>Lyrical</xsl:text>
        <xsl:text>Participatory</xsl:text>
        <xsl:text>Portrait</xsl:text>
        <xsl:text>Reflexive</xsl:text>
        <xsl:text>Street</xsl:text>
        <xsl:text>Structural</xsl:text>
        <xsl:text>Surrealist</xsl:text>
        <xsl:text>Text</xsl:text>
        <xsl:text>Trance</xsl:text>
        <xsl:text>Exploitation</xsl:text>
        <xsl:text>Fallen woman</xsl:text>
        <xsl:text>Family</xsl:text>
        <xsl:text>Fantasy</xsl:text>
        <xsl:text>Film noir</xsl:text>
        <xsl:text>Game</xsl:text>
        <xsl:text>Gangster</xsl:text>
        <xsl:text>Historical</xsl:text>
        <xsl:text>Home shopping</xsl:text>
        <xsl:text>Horror</xsl:text>
        <xsl:text>Industrial</xsl:text>
        <xsl:text>Instructional</xsl:text>
        <xsl:text>Interview</xsl:text>
        <xsl:text>Journalism</xsl:text>
        <xsl:text>Jungle</xsl:text>
        <xsl:text>Juvenile delinquency</xsl:text>
        <xsl:text>Lecture</xsl:text>
        <xsl:text>Legal</xsl:text>
        <xsl:text>Magazine</xsl:text>
        <xsl:text>Martial arts</xsl:text>
        <xsl:text>Maternal melodrama</xsl:text>
        <xsl:text>Medical</xsl:text>
        <xsl:text>Medical (Nonfiction)</xsl:text>
        <xsl:text>Melodrama</xsl:text>
        <xsl:text>Military</xsl:text>
        <xsl:text>Music</xsl:text>
        <xsl:text>Music video</xsl:text>
        <xsl:text>Musical</xsl:text>
        <xsl:text>Mystery</xsl:text>
        <xsl:text>Nature</xsl:text>
        <xsl:text>News</xsl:text>
        <xsl:text>Newsreel</xsl:text>
        <xsl:text>Opera</xsl:text>
        <xsl:text>Operetta</xsl:text>
        <xsl:text>Parody</xsl:text>
        <xsl:text>Police</xsl:text>
        <xsl:text>Political</xsl:text>
        <xsl:text>Pornography</xsl:text>
        <xsl:text>Prehistoric</xsl:text>
        <xsl:text>Prison</xsl:text>
        <xsl:text>Propaganda</xsl:text>
        <xsl:text>Public access</xsl:text>
        <xsl:text>Public affairs</xsl:text>
        <xsl:text>Reality-based</xsl:text>
        <xsl:text>Religion</xsl:text>
        <xsl:text>Religious</xsl:text>
        <xsl:text>Road</xsl:text>
        <xsl:text>Romance</xsl:text>
        <xsl:text>Science fiction</xsl:text>
        <xsl:text>Screwball comedy</xsl:text>
        <xsl:text>Show business</xsl:text>
        <xsl:text>Singing cowboy</xsl:text>
        <xsl:text>Situation comedy</xsl:text>
        <xsl:text>Slapstick comedy</xsl:text>
        <xsl:text>Slasher</xsl:text>
        <xsl:text>Soap opera</xsl:text>
        <xsl:text>Social guidance</xsl:text>
        <xsl:text>Social problem</xsl:text>
        <xsl:text>Sophisticated comedy</xsl:text>
        <xsl:text>Speculation</xsl:text>
        <xsl:text>Sponsored</xsl:text>
        <xsl:text>Sports</xsl:text>
        <xsl:text>Sports (Nonfiction)</xsl:text>
        <xsl:text>Survival</xsl:text>
        <xsl:text>Talk</xsl:text>
        <xsl:text>Thriller</xsl:text>
        <xsl:text>Training</xsl:text>
        <xsl:text>Travelogue</xsl:text>
        <xsl:text>Trick</xsl:text>
        <xsl:text>Trigger</xsl:text>
        <xsl:text>Variety</xsl:text>
        <xsl:text>War</xsl:text>
        <xsl:text>War (Nonfiction)</xsl:text>
        <xsl:text>Western</xsl:text>
        <xsl:text>Women</xsl:text>
        <xsl:text>Youth</xsl:text>
        <xsl:text>Yukon</xsl:text>
    </xsl:variable>
</xsl:stylesheet>

