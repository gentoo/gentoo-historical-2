# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/sylpheed-claws/sylpheed-claws-0.9.11.ebuild,v 1.7 2004/09/24 23:53:30 pvdabeel Exp $

IUSE="nls gnome xface dillo crypt spell imlib ssl ldap ipv6 pda clamav pdflib"

inherit eutils

GS_PN=ghostscript-viewer
GS_PV=0.6
MY_GS=${GS_PN}-${GS_PV}
MY_P="sylpheed-${PV}claws"
S=${WORKDIR}/${MY_P}
S2=${S}/src/plugins/${MY_GS}
DESCRIPTION="Bleeding edge version of Sylpheed"
HOMEPAGE="http://sylpheed-claws.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2
	pdflib? ( mirror://sourceforge/${PN}/${MY_GS}.tar.bz2 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha ~amd64"

DEPEND=">=sys-apps/sed-4
	=x11-libs/gtk+-1.2*
	pda? ( >=app-pda/jpilot-0.99 )
	ssl? ( >=dev-libs/openssl-0.9.6b )
	ldap? ( >=net-nds/openldap-2.0.7 )
	crypt? ( =app-crypt/gpgme-0.3.14 )
	dillo? ( www-client/dillo )
	gnome? ( >=media-libs/gdk-pixbuf-0.16 )
	imlib? ( >=media-libs/imlib-1.9.10 )
	spell? ( virtual/aspell-dict )
	xface? ( >=media-libs/compface-1.4 )
	pdflib? ( virtual/ghostscript )
	nls? ( >=sys-devel/gettext-0.12 )"

RDEPEND="${DEPEND}
	app-misc/mime-types
	net-mail/metamail
	x11-misc/shared-mime-info"

PROVIDE="virtual/sylpheed"

src_unpack() {
	unpack ${A}

	mv ${WORKDIR}/${MY_GS} ${S}/src/plugins

	# Change package name to sylpheed-claws ...
	for i in `find ${S}/ -name 'configure*'`; do
		sed -i "s/PACKAGE\=sylpheed/PACKAGE\=sylpheed-claws/" ${i}
	done

	# use shared-mime-info
	cd ${S}/src
	epatch ${FILESDIR}/procmime.patch

	# procmime API was changed between 0.9.6 and 0.9.7, 
	# default Makefile uses installed (=old) headers
	if use pdflib; then
		cd ${S2}
		epatch ${FILESDIR}/gv-procmime-Makefile.in.patch
	fi
}

src_compile() {
	local myconf

	myconf="${myconf} `use_enable gnome gdk-pixbuf`"
	myconf="${myconf} `use_enable imlib`"
	myconf="${myconf} `use_enable spell aspell`"
	myconf="${myconf} `use_enable ldap`"
	myconf="${myconf} `use_enable ssl openssl`"
	myconf="${myconf} `use_enable crypt gpgme`"
	myconf="${myconf} `use_enable ipv6`"
	myconf="${myconf} `use_enable pda jpilot`"
	myconf="${myconf} `use_enable nls`"
	myconf="${myconf} `use_enable dillo dillo-viewer-plugin`"
	myconf="${myconf} `use_enable clamav clamav-plugin`"
	myconf="${myconf} `use_enable xface compface`"

	echo ${myconf}

	econf \
		--program-suffix=-claws \
		--enable-spamassassin-plugin \
		${myconf} || die "./configure failed"

	make || die

	# build the extra tools
	cd ${S}/tools
	emake || die

	# build the ghostscript-viewer plugin
	if use pdflib; then
		cd ${S2}
		einfo "Compiling ghostscript-viewer plugin"
		PKG_CONFIG_PATH=${S} \
		CFLAGS="-I${S} -I${S}/src -I${S}/src/common -I${S}/src/gtk ${CFLAGS}" \
		CXXFLAGS="${CFLAGS}" \
			econf --with-sylpheed-dir=../.. || die

		emake || die
	fi

	cd ${S}
}

src_install() {
	make DESTDIR=${D} install || die

	local menuentry="/usr/share/gnome/apps/Internet/sylpheed.desktop"
	if use gnome; then
		dosed "s/Sylpheed/Sylpheed Claws/" ${menuentry}
		dosed "s/sylpheed/sylpheed-claws/" ${menuentry}
		mv ${D}${menuentry} ${D}${menuentry/sylpheed/sylpheed-claws}
	else
		rm -rf ${D}/usr/share/gnome
	fi

	dodir /usr/share/pixmaps
	mv sylpheed.png ${D}/usr/share/pixmaps/sylpheed-claws.png

	dodoc AUTHORS ChangeLog* INSTALL* NEWS README* TODO*
	docinto tools
	dodoc tools/README*

	# install the extra tools
	cd ${S}/tools
	exeinto /usr/lib/${PN}/tools
	doexe *.pl *.py *.rc *.conf gpg-sign-syl
	doexe launch_firebird tb2sylpheed update-po uudec

	# install the ghostscipt-viewer plugin
	if use pdflib; then
		cd ${S2}
		make plugindir=${D}/usr/lib/${PN}/plugins install || die
		docinto ${MY_GS}
		dodoc AUTHORS ChangeLog INSTALL NEWS README
	fi
}
