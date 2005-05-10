# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/emboss-kaptain/emboss-kaptain-0.97-r1.ebuild,v 1.1 2005/05/10 04:21:56 ribosome Exp $

DESCRIPTION="Graphical interfaces for EMBOSS and EMBASSY programs"
HOMEPAGE="http://userpage.fu-berlin.de/~sgmd/"
SRC_URI="http://genetik.fu-berlin.de/sgmd/EMBOSS.kaptns_${PV}.tar.gz"
LICENSE="GPL-1"

SLOT="0"
KEYWORDS="x86"
IUSE=""

S=${WORKDIR}/EMBOSS.kaptns_${PV}

DEPEND="kde-misc/kaptain
	app-editors/nedit
	sci-biology/emboss
	sci-biology/embassy-phylip
	sci-biology/embassy-domainatrix"

src_compile() {
	for i in *.kaptn; do
		sed -e 's/nc -noask/neditc -noask/' \
			-e 's/nc -svrname/neditc -svrname/' -i ${i} || die
	done
	cd EMBOSS
	for i in *; do
		cd "${i}"
		for j in *.desktop; do
			sed -i -e 's%Exec=%Exec=kaptain /usr/share/emboss-kaptain/%' ${j} \
				|| die
		done
		cd ${S}/EMBOSS
	done
	cd ${S}/Domainatrix/Domainatrix
	for i in *.desktop; do
		sed -i -e 's%Exec=%Exec=kaptain /usr/share/emboss-kaptain/%' ${i} || die
	done
}

src_install() {
	exeinto /usr/share/${PN}
	doexe *.kaptn
	doexe Domainatrix/*.kaptn
	mkdir -p ${D}/usr/share/applnk/EMBOSS/Domainatrix
	cp -r EMBOSS/* ${D}/usr/share/applnk/EMBOSS
	cp -r Domainatrix/Domainatrix/* ${D}/usr/share/applnk/EMBOSS/Domainatrix
}
