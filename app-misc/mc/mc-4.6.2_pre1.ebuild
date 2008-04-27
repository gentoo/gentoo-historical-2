# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mc/mc-4.6.2_pre1.ebuild,v 1.2 2008/04/27 10:58:47 drac Exp $

inherit eutils

MY_P=${P/_/-}

DESCRIPTION="GNU Midnight Commander is a s-lang based file manager."
HOMEPAGE="http://www.gnu.org/software/mc"
SRC_URI="http://ftp.gnu.org/gnu/mc/${MY_P}.tar.gz
	http://dev.gentoo.org/~drac/${P}-patchset-1.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="gpm nls samba X"

RDEPEND=">=dev-libs/glib-2
	>=sys-libs/slang-2.1.3
	gpm? ( sys-libs/gpm )
	X? ( x11-libs/libX11
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libSM )
	samba? ( net-fs/samba )
	kernel_linux? ( sys-fs/e2fsprogs )
	app-arch/zip
	app-arch/unzip"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/patches/*.patch
}

src_compile() {
	# Default is slang for unicode in Gentoo (which is also upstream default)
	local myconf="--with-vfs --with-ext2undel --with-edit --enable-charset --with-screen=slang"

	if use samba; then
		myconf+=" --with-samba --with-configdir=/etc/samba --with-codepagedir=/var/lib/samba/codepages"
	else
		myconf+=" --without-samba"
	fi

	econf --disable-dependency-tracking \
		$(use_enable nls) \
		$(use_with gpm gpm-mouse) \
		$(use_with X x) \
		${myconf}

	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS FAQ HACKING MAINTAINERS NEWS README* TODO

	# Install ebuild syntax
	insinto /usr/share/mc/syntax
	doins "${FILESDIR}"/ebuild.syntax
}
