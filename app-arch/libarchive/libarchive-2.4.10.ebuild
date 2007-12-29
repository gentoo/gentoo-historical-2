# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/libarchive/libarchive-2.4.10.ebuild,v 1.1 2007/12/29 15:41:59 flameeyes Exp $

inherit eutils libtool toolchain-funcs

DESCRIPTION="BSD tar command"
HOMEPAGE="http://people.freebsd.org/~kientzle/libarchive"
SRC_URI="http://people.freebsd.org/~kientzle/libarchive/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="build static acl xattr kernel_linux"

RDEPEND="!dev-libs/libarchive
	kernel_linux? (
		acl? ( sys-apps/acl )
		xattr? ( sys-apps/attr )
	)
	!static? ( !build? (
		app-arch/bzip2
		sys-libs/zlib ) )"
DEPEND="${RDEPEND}
	kernel_linux? ( sys-fs/e2fsprogs
		virtual/os-headers )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	elibtoolize
	epunt_cxx
}

src_compile() {
	local myconf

	if ! use static && ! use build ; then
		myconf="--enable-bsdtar=shared --enable-bsdcpio=shared"
	fi

	econf --bindir=/bin --enable-bsdcpio \
		$(use_enable acl) $(use_enable xattr) \
		${myconf} || die "econf failed."

	emake || die "emake failed."
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed."

	# Create tar symlink for FreeBSD
	if [[ ${CHOST} == *-freebsd* ]]; then
		dosym bsdtar /bin/tar
		dosym bsdtar.1 /usr/share/man/man1/tar.1
		# We may wish to switch to symlink bsdcpio to cpio too one day
	fi

	dodoc NEWS README

	if use build; then
		rm -rf "${D}"/usr
		rm -rf "${D}"/lib/*.so*
		return 0
	fi

	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/*.so* "${D}"/$(get_libdir)
	gen_usr_ldscript libarchive.so
}
