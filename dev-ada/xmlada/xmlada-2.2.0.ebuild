# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/xmlada/xmlada-2.2.0.ebuild,v 1.1 2006/11/16 15:33:23 george Exp $

inherit gnat versionator

IUSE=""

Name="xmlada-gpl"
S="${WORKDIR}"/${Name}-${PV}

DESCRIPTION="XML library for Ada"
HOMEPAGE="http://libre2.adacore.com/xmlada/"
SRC_URI="https://libre2.adacore.com/xmlada/${Name}-${PV}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="virtual/gnat
	virtual/tetex
	sys-apps/texinfo
	>=sys-apps/sed-4"
RDEPEND=""


lib_compile()
{
	econf || die "econf failed"
	emake || die "make failed"
}

# NOTE: we are using $1 - the passed gnat profile name
lib_install() {
	make PREFIX=${DL} install || die "install failed"

	# fix xmlada-config hardsets locations
	sed -i -e "s:\${prefix}/include/xmlada:${AdalibSpecsDir}/${PN}:" \
		-e "s:\${prefix}/lib/xmlada:${AdalibLibTop}/$1/${PN}/lib:" \
		-e "s:\${prefix}/lib:${AdalibLibTop}/$1/${PN}/lib:g" \
		${DL}/bin/xmlada-config

	# now move stuff to proper location and delete extras
#	mv ${DL}/bin/xmlada-config ${DL}/lib/* ${DL}/include/${PN}/*.ali ${DL}
	rm -rf ${DL}/include ${DL}/share
}

src_install ()
{
	cd ${S}
	dodir ${AdalibSpecsDir}/${PN}
	insinto ${AdalibSpecsDir}/${PN}
	doins dom/*.ad? input_sources/*.ad? sax/*.ad? unicode/*.ad? schema/*.ad?

	#set up environment
	echo "PATH=%DL%/bin" > ${LibEnv}
	echo "LDPATH=%DL%/lib" >> ${LibEnv}
	echo "ADA_OBJECTS_PATH=%DL%/lib" >> ${LibEnv}
	echo "ADA_INCLUDE_PATH=/usr/include/ada/${PN}" >> ${LibEnv}

	gnat_src_install

	dodoc AUTHORS COPYING README TODO features
	dohtml docs/*.html
	doinfo docs/*.info
	# give a proper name to the info file
	mv ${D}/usr/share/info/xml.info.gz ${D}/usr/share/info/${PN}.info.gz
	insinto /usr/share/doc/${PF}
	doins docs/*.pdf distrib/xmlada_gps.py

	dodir /usr/share/doc/${PF}/examples
	insinto /usr/share/doc/${PF}/examples
	doins -r docs/{dom,sax,schema}
}
