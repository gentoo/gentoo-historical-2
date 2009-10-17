# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/davfs2/davfs2-1.3.3.ebuild,v 1.4 2009/10/17 02:23:13 arfrever Exp $

EAPI="2"

inherit autotools eutils linux-mod

DESCRIPTION="a Linux file system driver that allows you to mount a WebDAV server as a local disk drive. Davfs2 uses fuse (or coda) for kernel driver and neon for WebDAV interface"
HOMEPAGE="http://dav.sourceforge.net"
SRC_URI="mirror://sourceforge/dav/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"
RESTRICT="test"

DEPEND="dev-libs/libxml2
		net-misc/neon
		sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/fortify_sources_fix.patch"

	sed -e "s/^NE_REQUIRE_VERSIONS.*28/& 29 30/" -i configure.ac
	eautoreconf
}

src_configure() {
	local myconf

	if use debug; then
		myconf="--with-debug"
	fi

	econf \
		--enable-largefile \
		${myconf}
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog FAQ INSTALL.davfs2 NEWS README \
		README.translators THANKS TODO

	# remove wrong locations created by install
	rm -r "${D}/usr/share/doc/davfs2"
	rm -r "${D}/usr/share/davfs2"

	dodir /var/run/mount.davfs
	keepdir /var/run/mount.davfs
	fowners root:users /var/run/mount.davfs
	fperms 1774 /var/run/mount.davfs

	# ignore nobody's home
	cat>>"${D}/etc/davfs2/davfs2.conf"<<EOF

# nobody is a system account in Gentoo
ignore_home nobody
EOF
}
