# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# /space/gentoo/cvsroot/gentoo-x86/media-sound/mbrola/mbrola-3.0.1h.ebuild,v 1.0
# 2002/05/18 17:25:12 naz Exp

S=${WORKDIR}
URL="http://tcts.fpms.ac.be/synthesis/mbrola"
DESCRIPTION="us1, us2, and us3 mbrola voice libraries for Festival TTS"
SRC_URI="${URL}/bin/pclinux/mbr301h.zip
${URL}/dba/us1/us1-980512.zip
${URL}/dba/us2/us2-980812.zip
${URL}/dba/us3/us3-990208.zip"
HOMEPAGE="http://tcts.fpms.ac.be/synthesis/mbrola.html"

DEPEND=">=media-sound/festival-1.4.2"

src_install () {

	# Take care of main binary
	mv mbrola-linux-i386 mbrola
	dobin mbrola
	dodoc readme.txt

	# Now install the vioces
	FESTLIB=/usr/lib/festival/voices/english
	insinto ${FESTLIB}/us1_mbrola
	doins us1/us1 us1/us1mrpa
	insinto ${FESTLIB}/us1_mbrola/TEST
	doins us1/TEST/*
	dodoc us1/us1.txt

	insinto ${FESTLIB}/us2_mbrola
	doins us2/us2
	insinto ${FESTLIB}/us2_mbrola/TEST
	doins us2/TEST/*
	dodoc us2/us2.txt

	insinto ${FESTLIB}/us3_mbrola
	doins us3/us3
	insinto ${FESTLIB}/us3_mbrola/TEST
	doins us3/TEST/*
	dodoc us3/us3.txt

}

