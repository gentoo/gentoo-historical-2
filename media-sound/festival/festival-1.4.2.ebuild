# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/festival/festival-1.4.2.ebuild,v 1.3 2002/07/19 13:13:39 seemant Exp $

S=${WORKDIR}/${PN}
T=${WORKDIR}/speech_tools
DESCRIPTION="Festival Test to Speech engine"
HOMEPAGE="http://www.cstr.ed.ac.uk/"
SITE="http://www.speech.cs.cmu.edu/${PN}/cstr/${PN}/${PV}"
SRC_URI="${SITE}/${P}-release.tar.gz
	${SITE}/festlex_CMU.tar.gz
	${SITE}/festlex_OALD.tar.gz
	${SITE}/festlex_POSLEX.tar.gz
	${SITE}/festvox_don.tar.gz
	${SITE}/festvox_ellpc11k.tar.gz
	${SITE}/festvox_kallpc16k.tar.gz
	${SITE}/festvox_kedlpc16k.tar.gz
	${SITE}/festvox_rablpc16k.tar.gz
	${SITE}/festvox_us1.tar.gz
	${SITE}/festvox_us2.tar.gz
	${SITE}/festvox_us3.tar.gz
	${SITE}/speech_tools-1.2.2-release.tar.gz
	http://www.ibiblio.org/gentoo/distfiles/festival-1.4.2-patch.tar.bz2"

SLOT="0"
LICENSE="FESTIVAL BSD as-is"
KEYWORDS="x86"

src_compile() {
	cd ${T}
	econf || die
	patch -p1 < ${WORKDIR}/speech_tools.patch || die
	
	make || die

	cd ${S}
	econf || die
	patch -p1 < ${WORKDIR}/festival.patch || die
	
	make || die

	# Need to fix saytime to look for festival in the correct spot
	cp examples/saytime examples/saytime.orig
	sed "s:${WORKDIR}/festival/bin/festival:/usr/bin/festival:" \
		examples/saytime.orig > examples/saytime

	# And do the same thing for text2wave
	cp bin/text2wave bin/text2wave.orig
	sed "s:${WORKDIR}/festival/bin/festival:/usr/bin/festival:" \
		bin/text2wave.orig > bin/text2wave
}

src_install () {

	. install.sh || die
	
	# Install the docs
	dodoc ACKNOWLEDGMENTS COPYING NEWS README

}

pkg_postinst() {

	echo
	echo '#########################################################'
	echo '#                                                       #'
	echo '#     To test festival, simply type:                    #'
	echo '#         "saytime"                                     #'
	echo '#                                                       #'
	echo '#     Or for something more fun:                        #'
	echo '#         "echo "Gentoo can speak" | festival --tts"    #'
	echo '#                                                       #'
	echo '#########################################################'
	echo

}
