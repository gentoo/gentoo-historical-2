# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelibs/kdelibs-3.4.0_beta1.ebuild,v 1.3 2005/01/14 19:42:18 greg_g Exp $

inherit kde eutils flag-o-matic
set-kdedir 3.4

MY_PV=3.3.91
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="KDE libraries needed by all kde programs"
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://kde/unstable/${MY_PV}/src/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="3.4"
KEYWORDS="~x86"
IUSE="alsa arts cups doc jpeg2k kerberos openexr ssl tiff"

# kde.eclass has kdelibs in DEPEND, and we can't have that in here.
# so we recreate the entire DEPEND from scratch.
RDEPEND="arts? ( ~kde-base/arts-${PV} )
	>=x11-libs/qt-3.3.3
	app-arch/bzip2
	>=dev-libs/libxslt-1.1.4
	>=dev-libs/libxml2-2.6.6
	>=dev-libs/libpcre-4.2
	ssl? ( >=dev-libs/openssl-0.9.7d )
	alsa? ( media-libs/alsa-lib )
	cups? ( >=net-print/cups-1.1.19 )
	tiff? ( media-libs/tiff )
	kerberos? ( virtual/krb5 )
	jpeg2k? ( x86? ( media-libs/jasper ) )
	openexr? ( >=media-libs/openexr-1.2 )
	virtual/fam
	virtual/ghostscript
	media-libs/libart_lgpl
	net-dns/libidn"
# TODO
# - add dependency on mDNSResponder when it enters portage
#   ('dnssd' local USE flag?)
# - add support for dbus/hal for 'media:' ioslave:
#     hal? ( >=sys-apps/dbus-0.22-r3    (for proper Qt support)
#            >=sys-apps/hal-0.4 )
#   the 'hal' flag should become global,
#   since it's already used by 5 ebuilds.

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.58
	>=sys-devel/automake-1.8
	doc? ( app-doc/doxygen )
	sys-devel/gettext
	!kde-misc/kgamma"

src_unpack() {
	kde_src_unpack

	# was forgotten by kde devs, applied for 3.4.0_beta2
	epatch ${FILESDIR}/post-3.3.2-kdelibs-kio.diff

	# applied for 3.4.0_beta2
	epatch ${FILESDIR}/reference-list-rev-1.3.diff
}

src_compile() {
	kde_src_compile myconf

	myconf="$myconf --with-distribution=Gentoo --enable-libfam --enable-dnotify"
	myconf="$myconf $(use_with alsa) $(use_enable cups) $(use_with arts)"

	use ssl && myconf="$myconf --with-ssl-dir=/usr" || myconf="$myconf --without-ssl"

	use kerberos || myconf="$myconf --with-gssapi=no"

	use x86 && myconf="$myconf --enable-fast-malloc=full"
	use ppc64 && append-flags -mminimal-toc

	kde_src_compile configure make

	use doc && make apidox
}

src_install() {
	kde_src_install

	use doc && make DESTDIR=${D} install-apidox

	# needed to fix lib64 issues on amd64, see bug #45669
	use amd64 && ln -s ${KDEDIR}/lib ${D}/${KDEDIR}/lib64


	if ! use arts ; then

		dodir /etc/env.d

		cat <<EOF > ${D}/etc/env.d/46kdepaths-${SLOT} # number goes down with version upgrade
PATH=${PREFIX}/bin
ROOTPATH=${PREFIX}/sbin:${PREFIX}/bin
LDPATH=${PREFIX}/lib
CONFIG_PROTECT="${PREFIX}/share/config ${PREFIX}/env ${PREFIX}/shutdown"
EOF
	fi

}
