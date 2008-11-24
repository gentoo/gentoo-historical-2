# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fbiterm/fbiterm-0.5-r2.ebuild,v 1.1 2008/11/24 16:52:22 matsuu Exp $

inherit autotools eutils multilib

IUSE=""

DESCRIPTION="Framebuffer internationalized terminal emulator"
HOMEPAGE="http://www-124.ibm.com/linux/projects/iterm/"
SRC_URI="http://www-124.ibm.com/linux/projects/iterm/releases/iterm-${PV}.tar.gz"

LICENSE="CPL-0.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/libXfont
	>=media-libs/freetype-2
	x11-libs/libiterm-mbt
	sys-libs/zlib"
RDEPEND="${DEPEND}
	media-fonts/font-sony-misc
	media-fonts/unifont"

S="${WORKDIR}/iterm/unix/fbiterm"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PF}-gentoo.diff"
	eautoreconf
}

src_compile() {
	econf --x-includes=/usr/include \
		--x-libraries=/usr/$(get_libdir) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README*
}

pkg_postinst() {
	elog
	elog "1. If you haven't created your locale, run localedef."
	elog "# localedef -v -c -i en_GB -f UTF-8 en_GB.UTF-8"
	elog "(If you want to use other locales such as Japanese, replace"
	elog "en_GB with ja_JP and en_GB.UTF-8 with ja_JP.UTF-8, respectively)"
	elog
	elog "2. Set enviroment variable."
	elog "% export LC_CTYPE=en_GB.UTF-8 (sh, bash, zsh, ...)"
	elog "> setenv LC_CTYPE en_GB.UTF-8 (csh, tcsh, ...)"
	elog "(Again, if you want to use Japanese locale, create ja_JP.UTF-8"
	elog " locale by localedef and set LC_CTYPE to ja_JP.UTF-8)"
	elog
	elog "3. Run unicode_start."
	elog "% unicode_start"
	elog
	elog "4. Run fbiterm."
	elog "% fbiterm"
	elog
}
