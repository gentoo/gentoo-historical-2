# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelibs/kdelibs-3.2.0_beta2.ebuild,v 1.10 2004/01/04 14:57:11 caleb Exp $
inherit kde

need-autoconf 2.5
set-kdedir ${PV}

MY_PV=3.1.94
S=${WORKDIR}/${PN}-${MY_PV}

IUSE="alsa cups ipv6 ssl doc ldap"
DESCRIPTION="KDE libraries needed by all kde programs"
KEYWORDS="~x86"
HOMEPAGE="http//www.kde.org/"
SLOT="3.2"
LICENSE="GPL-2 LGPL-2"
SRC_URI="mirror://kde/unstable/${MY_PV}/src/${PN}-${MY_PV}.tar.bz2"

# kde.eclass has kdelibs in DEPEND, and we can't have that in here.
# so we recreate the entire DEPEND from scratch.
DEPEND=">=app-arch/bzip2-1.0.2
	>=dev-libs/libxslt-1.0.31
	>=dev-libs/libxml2-2.5.8
	>=dev-libs/libpcre-3.9
	ssl? ( >=dev-libs/openssl-0.9.6k )
	alsa? ( media-libs/alsa-lib virtual/alsa )
	cups? ( >=net-print/cups-1.1.19 )
	ldap? ( >=net-nds/openldap-2.0.25 )
	media-libs/tiff
	>=app-admin/fam-2.6.10
	virtual/ghostscript
	media-libs/libart_lgpl
	sys-devel/gettext
	~kde-base/arts-1.2.0_beta2
	>=x11-libs/qt-3.2.0"

RDEPEND="$DEPEND
	app-text/sgml-common
	cups? ( net-print/cups )
	doc? ( app-doc/doxygen )
	dev-lang/python"

src_unpack() {
	kde_src_unpack
	cd ${S} && make -f admin/Makefile.common && aclocal
	cd ${S}/kio/misc/kpac
	cp Makefile.am Makefile.am.orig
	sed -e 's: $(bindir): $(DESTDIR)/$(bindir):g' Makefile.am.orig > Makefile.am
	rm Makefile.am.orig
#	use alpha && cd ${S} && epatch ${FILESDIR}/${P}-kjs-alphaev6-gcc3-workaround.patch
}

src_compile() {

	kde_src_compile myconf

	myconf="$myconf --with-distribution=Gentoo --enable-libfam --enable-dnotify"
	myconf="$myconf `use_with alsa` `use_enable cups`"

	use ipv6	|| myconf="$myconf --with-ipv6-lookup=no"
	use ssl		&& myconf="$myconf --with-ssl-dir=/usr"	|| myconf="$myconf --without-ssl"
	use alsa	&& myconf="$myconf --with-alsa" || myconf="$myconf --without-alsa"
	use cups	&& myconf="$myconf --enable-cups" || myconf="$myconf --disable-cups"

	use x86 && myconf="$myconf --enable-fast-malloc=full"

	kde_src_compile configure make

	use doc && make apidox
}

src_install() {
	kde_src_install
	dohtml *.html

	if [ `use doc` ]; then
		einfo "Copying API documentation..."
		dodir ${KDEDIR}/share/doc/HTML/en/kdelibs-apidocs
		cp -r ${S}/apidocs/* ${D}/$KDEDIR/share/doc/HTML/en/kdelibs-apidocs
	else
		rm -r ${D}/$KDEDIR/share/doc/HTML/en/kdelibs-apidocs
	fi
}

pkg_postinst() {
	if [ `use doc` ]; then
		rm $KDEDIR/share/doc/HTML/en/kdelibs-apidocs/common
		ln -sf $KDEDIR/share/doc/HTML/en/common \
			$KDEDIR/share/doc/HTML/en/kdelibs-apidocs/common
	fi
}
