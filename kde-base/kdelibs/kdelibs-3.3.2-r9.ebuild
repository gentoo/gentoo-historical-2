# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelibs/kdelibs-3.3.2-r9.ebuild,v 1.8 2005/05/06 03:40:58 weeve Exp $

inherit kde eutils flag-o-matic
set-kdedir 3.3

DESCRIPTION="KDE libraries needed by all kde programs"
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://kde/stable/${PV}/src/${PN}-${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="3.3"
KEYWORDS="amd64 hppa ~mips ppc ppc64 sparc x86 alpha ia64"
IUSE="alsa arts cups doc ipv6 kerberos ldap spell ssl tiff"

# kde.eclass has kdelibs in DEPEND, and we can't have that in here.
# so we recreate the entire DEPEND from scratch.
RDEPEND="arts? ( ~kde-base/arts-1.3.2 )
	>=x11-libs/qt-3.3.3
	app-arch/bzip2
	>=dev-libs/libxslt-1.1.4
	>=dev-libs/libxml2-2.6.6
	>=dev-libs/libpcre-4.2
	ssl? ( >=dev-libs/openssl-0.9.7d )
	alsa? ( media-libs/alsa-lib virtual/alsa )
	cups? ( >=net-print/cups-1.1.19 )
	ldap? ( >=net-nds/openldap-2.1.26 )
	tiff? ( media-libs/tiff )
	spell? ( || ( app-text/aspell
		      app-text/ispell ) )
	kerberos? ( virtual/krb5 )
	virtual/fam
	virtual/ghostscript
	media-libs/libart_lgpl
	net-dns/libidn
	sys-devel/gettext"

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.58
	>=sys-devel/automake-1.8
	doc? ( app-doc/doxygen )
	!kde-misc/kgamma"

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/post-3.3.2-kdelibs-kio.diff
	epatch ${FILESDIR}/post-3.3.2-kdelibs-htmlframes2.patch
	epatch ${FILESDIR}/post-3.3.2-kdelibs-kioslave.patch

	# see bug #67748. Patch applied in kdelibs 3.4.x.
	epatch ${FILESDIR}/${P}-aspell-dir.patch

	# see bug #77127. Patch applied in kdelibs 3.3.3.
	epatch ${FILESDIR}/${P}-anchor-fix.patch

	# see bug #81652.
	epatch ${FILESDIR}/kde3-dcopidlng.patch

	# see bug #63529.
	epatch ${FILESDIR}/${P}-ppc64.patch

	# see bug #83814.
	epatch ${FILESDIR}/post-3.3.2-kdelibs-dcop.patch

	# see bug #81110.
	epatch ${FILESDIR}/post-3.3.2-kdelibs-idn-2.patch

	# kimgio input validation errors, see bug #88862
	cd ${S}/kimgio && patch -p0 < "${FILESDIR}/post-3.3.2-kdelibs-kimgio-2.diff"
}

src_compile() {
	kde_src_compile myconf

	myconf="$myconf --with-distribution=Gentoo --enable-libfam --enable-dnotify"
	myconf="$myconf $(use_with alsa) $(use_enable cups) $(use_with arts)"

	use ipv6	|| myconf="$myconf --with-ipv6-lookup=no"
	use ssl		&& myconf="$myconf --with-ssl-dir=/usr"	|| myconf="$myconf --without-ssl"

	use kerberos || myconf="$myconf --with-gssapi=no"

	use x86 && myconf="$myconf --enable-fast-malloc=full"
	use ppc64 && append-flags -mminimal-toc

	kde_src_compile configure make

	use doc && make apidox
}

src_install() {
	kde_src_install
	dohtml *.html

	if use doc ; then
		einfo "Copying API documentation..."
		dodir ${KDEDIR}/share/doc/HTML/en/kdelibs-apidocs
		cp -r ${S}/apidocs/* ${D}/$KDEDIR/share/doc/HTML/en/kdelibs-apidocs
	else
		rm -r ${D}/$KDEDIR/share/doc/HTML/en/kdelibs-apidocs
	fi

	# needed to fix lib64 issues on amd64, see bug #45669
	use amd64 && ln -s ${KDEDIR}/lib ${D}/${KDEDIR}/lib64
	# Needed to create lib -> lib64 symlink for amd64 2005.0 profile
	if [ "${SYMLINK_LIB}" = "yes" ]; then
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) ${KDEDIR}/lib
	fi

	if ! use arts ; then

		dodir /etc/env.d

		echo "PATH=${PREFIX}/bin
ROOTPATH=${PREFIX}/sbin:${PREFIX}/bin
LDPATH=${PREFIX}/lib
CONFIG_PROTECT=\"${PREFIX}/share/config ${PREFIX}/env ${PREFIX}/shutdown\"" > ${D}/etc/env.d/47kdepaths-3.3.1 # number goes down with version upgrade

	fi
}

pkg_postinst() {
	if use doc ; then
		rm $KDEDIR/share/doc/HTML/en/kdelibs-apidocs/common
		ln -sf $KDEDIR/share/doc/HTML/en/common \
			$KDEDIR/share/doc/HTML/en/kdelibs-apidocs/common
	fi
}
