# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwinfo/hwinfo-18.1.ebuild,v 1.2 2010/09/30 22:58:06 ssuominen Exp $

EAPI=2
inherit multilib rpm toolchain-funcs

DESCRIPTION="hwinfo is the hardware detection tool used in SuSE Linux."
HOMEPAGE="http://www.opensuse.org/"
SRC_URI="http://download.opensuse.org/source/factory/repo/oss/suse/src/${P}-1.9.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/libx86emu"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.17"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	# Avoid -I directories for dbus because HAL is obsolete.
	sed -i -e '/CFLAGS/d' src/hd/Makefile || die
	# Respect LDFLAGS.
	sed -i -e 's:$(CC) -shared:& $(LDFLAGS):' src/Makefile || die
	sed -i -e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' src/ids/Makefile || die

	# Respect MAKE variable. Skip forced -pipe and -g. Respect LDFLAGS.
	sed -i \
		-e 's:make:$(MAKE):' \
		-e 's:-pipe -g::' \
		-e 's:LDFLAGS.*=:LDFLAGS +=:' \
		Makefile{,.common} || die
}

src_compile() {
	emake CC="$(tc-getCC)" RPM_OPT_FLAGS="${CFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" install || die

	dodoc changelog README
	doman doc/hwinfo.8
	insinto /usr/share/doc/${PF}/examples
	doins doc/example*.c
}
