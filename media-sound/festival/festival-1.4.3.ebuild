# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/festival/festival-1.4.3.ebuild,v 1.4 2004/02/10 19:14:48 eradicator Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Festival Text to Speech engine"
GCCPV=`gcc -dumpversion`
IUSE="asterisk"
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
	doc? ( ${SITE}/festdoc-1.4.2.tar.gz )"

	# Keeping these things in external patch files (that dont even live in
	# the files subdir) makes it far too difficult to modify the ebuild. These
	# patches are easily replaced by a bit of sed, consistant with the rest of
	# the ebuild, and moving the ebuild commands from the external shell script
	# into the ebuild where they belong.

SLOT="0"
LICENSE="FESTIVAL BSD as-is"
KEYWORDS="~x86"

RDEPEND="virtual/glibc"
DEPEND=">=media-sound/speech-tools-1.2.3"

src_unpack() {
	unpack ${P}-release.tar.gz
	unpack festlex_CMU.tar.gz
	unpack festlex_OALD.tar.gz
	unpack festlex_POSLEX.tar.gz
	unpack festvox_don.tar.gz
	unpack festvox_ellpc11k.tar.gz
	unpack festvox_kallpc16k.tar.gz
	unpack festvox_kedlpc16k.tar.gz
	unpack festvox_rablpc16k.tar.gz
	unpack festvox_us1.tar.gz
	unpack festvox_us2.tar.gz
	unpack festvox_us3.tar.gz
	epatch ${FILESDIR}/${PN}-gcc3.3.diff

	use asterisk && epatch ${FILESDIR}/${P}-asterisk.patch
}

src_compile() {

	mv config/config.in config/config.in.org
	cat config/config.in.org | sed 's@EST=$(TOP)/../speech_tools@EST=/usr/lib/speech-tools@' > config/config.in

	econf

	# testsuite still fails to build under gcc-3.2
	mv Makefile Makefile.orig
	sed -e '/^BUILD_DIRS =/s/testsuite//' Makefile.orig > Makefile

	pushd config/modules/
	cp editline.mak editline.mak.orig
	sed -e '/^MODULE_LIBS/s/-ltermcap/-lncurses/' editline.mak.orig \
		> editline.mak
	popd

	# emake worked for me on SMP
	#emake did not work for me because I had -j5. If there is anything greater than
	#-j2, emake dies.
	#zhen@gentoo.org
	make || die

	cd ${S}
	econf
	pushd src/arch/festival/
	cp festival.cc festival.cc.orig
	sed -e '/^const char \*festival_libdir/s:FTLIBDIR:"/usr/lib/festival":' \
		festival.cc.orig  > festival.cc
	pushd
	pushd config/modules/
	cp editline.mak editline.mak.orig
	sed -e '/^MODULE_LIBS/s/-ltermcap/-lncurses/' editline.mak.orig \
		> editline.mak
	pushd

	# emake failed for me on SMP
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

src_install() {
	# Install the binaries
	cd ${WORKDIR}/festival/src/main
	dobin festival
	cd ${WORKDIR}/festival/examples
	dobin saytime
	cd ${WORKDIR}/festival/bin
	dobin text2wave
	cd ${WORKDIR}/festival/lib/etc/*Linux*
	dobin audsp

	einfo ""
	einfo "Please ignore errors about skipped directories. They are harmless."
	einfo ""

	# Install the main libraries
	insinto /usr/lib/festival
	doins ${WORKDIR}/festival/lib/*

	# Install the dicts and vioces
	FESTLIB=${WORKDIR}/festival/lib
	DESTLIB=/usr/lib/festival
	insinto ${DESTLIB}/dicts
	doins ${FESTLIB}/dicts/COPYING.poslex \
		${FESTLIB}/dicts/wsj.wp39.poslexR ${FESTLIB}/dicts/wsj.wp39.tri.ngrambin
	insinto ${DESTLIB}/dicts/cmu
	doins ${FESTLIB}/dicts/cmu/*
	insinto ${DESTLIB}/dicts/oald
	doins ${FESTLIB}/dicts/oald/*

	FESTLIB=${WORKDIR}/festival/lib/voices/spanish/el_diphone
	DESTLIB=/usr/lib/festival/voices/spanish/el_diphone
	insinto ${DESTLIB}/festvox
	doins ${FESTLIB}/festvox/*
	insinto ${DESTLIB}/group
	doins ${FESTLIB}/group/*

	FESTLIB=${WORKDIR}/festival/lib/voices/english
	DESTLIB=/usr/lib/festival/voices/english
	insinto ${DESTLIB}/don_diphone
	doins ${FESTLIB}/don_diphone/*
	insinto ${DESTLIB}/don_diphone/festvox
	doins ${FESTLIB}/don_diphone/festvox/*

	insinto ${DESTLIB}/kal_diphone
	doins ${FESTLIB}/kal_diphone/*
	insinto ${DESTLIB}/kal_diphone/festvox
	doins ${FESTLIB}/kal_diphone/festvox/*
	insinto ${DESTLIB}/kal_diphone/group
	doins ${FESTLIB}/kal_diphone/group/*

	insinto ${DESTLIB}/ked_diphone
	doins ${FESTLIB}/ked_diphone/*
	insinto ${DESTLIB}/ked_diphone/festvox
	doins ${FESTLIB}/ked_diphone/festvox/*
	insinto ${DESTLIB}/ked_diphone/group
	doins ${FESTLIB}/ked_diphone/group/*

	insinto ${DESTLIB}/rab_diphone
	doins ${FESTLIB}/rab_diphone/*
	insinto ${DESTLIB}/rab_diphone/festvox
	doins ${FESTLIB}/rab_diphone/festvox/*
	insinto ${DESTLIB}/rab_diphone/group
	doins ${FESTLIB}/rab_diphone/group/*
	insinto ${DESTLIB}/us1_mbrola

	doins ${FESTLIB}/us1_mbrola/*
	insinto ${DESTLIB}/us1_mbrola/festvox
	doins ${FESTLIB}/us1_mbrola/festvox/*

	insinto ${DESTLIB}/us2_mbrola
	doins ${FESTLIB}/us2_mbrola/*
	insinto ${DESTLIB}/us2_mbrola/festvox
	doins ${FESTLIB}/us2_mbrola/festvox/*

	insinto ${DESTLIB}/us3_mbrola
	doins ${FESTLIB}/us3_mbrola/*
	insinto ${DESTLIB}/us3_mbrola/festvox
	doins ${FESTLIB}/us3_mbrola/festvox/*

	# Install the docs
	cd ${S} # needed
	into /usr
	dodoc ACKNOWLEDGMENTS COPYING NEWS README
	doman doc/festival.1 doc/festival_client.1

	cd ${WORKDIR}/festdoc-1.4.2/festival/html
	dohtml *.html

	# Sample .festivalrc
	cd ${D}/usr/lib/festival
	cat << EOF > festivalrc
(Parameter.set 'Audio_Method 'linux16audio)
;(Parameter.set 'Audio_Method 'esdaudio)
;(Parameter.set 'Audio_Method 'mplayeraudio)
;(Parameter.set 'Audio_Method 'sunaudio)

; American female
;(set! voice_default 'voice_us1_mbrola)
EOF
}

pkg_postinst() {
	einfo
	einfo '    To test festival, simply type:'
	einfo '        "saytime"'
	einfo
	einfo '    Or for something more fun:'
	einfo '        "echo "Gentoo can speak" | festival --tts"'
	einfo
	einfo '    A sample ~/.festivalrc is provided in'
	einfo '        /usr/lib/festival/festivalrc'
	einfo
	einfo '    Emerge mbrola to enable some additional voices'
	einfo
}

