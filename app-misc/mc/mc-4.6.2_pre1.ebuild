# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mc/mc-4.6.2_pre1.ebuild,v 1.4 2008/05/05 17:12:22 drac Exp $

EAPI=1

inherit eutils

MY_P=${P/_/-}

DESCRIPTION="GNU Midnight Commander is a s-lang based file manager."
HOMEPAGE="http://www.gnu.org/software/mc"
SRC_URI="http://ftp.gnu.org/gnu/mc/${MY_P}.tar.gz
	http://dev.gentoo.org/~drac/${MY_P}-patches-1.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="gpm nls samba +unicode X"

RDEPEND=">=dev-libs/glib-2
	unicode? ( >=sys-libs/slang-2.1.3 )
	!unicode? ( sys-libs/ncurses )
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

	use unicode || \
		EPATCH_EXCLUDE="48_all_deb_utf8-slang2.patch 60_all_deb_recode.patch"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patches

	# Prevent lazy bindings in cons.saver binary for bug #135009
	sed -i -e "s:^\(cons_saver_LDADD = .*\):\1 -Wl,-z,now:" \
		src/Makefile.in || die "sed failed."
}

src_compile() {
	local myconf="--with-vfs --with-ext2undel --enable-charset --with-edit"

	if use unicode; then
		myconf+=" --with-screen=slang"
	else
		myconf+=" --with-screen=ncurses"
	fi

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

	# Install cons.saver setuid to actually work
	fperms u+s /usr/libexec/mc/cons.saver

	# Install ebuild syntax
	insinto /usr/share/mc/syntax
	doins "${FILESDIR}"/ebuild.syntax
}
