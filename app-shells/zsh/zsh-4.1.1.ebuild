# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh/zsh-4.1.1.ebuild,v 1.1 2003/07/23 20:21:36 usata Exp $

IUSE="maildir ncurses"

DESCRIPTION="UNIX Shell similar to the Korn shell"
HOMEPAGE="http://www.zsh.org/"

# New zshall.1 generated with the following, run in Doc:
# perl -nle'$_ = `cat $1` if /^\.so man1\/(.+\.1)/;print' zshall.1
ZSHALL="${P}-zshall-gentoo.diff"
SRC_URI="ftp://ftp.zsh.org/pub/${P}.tar.bz2
	http://dev.gentoo.org/~usata/distfiles/${ZSHALL}.bz2
	cjk? ( http://www.ono.org/software/dist/${P}-euc-0.2.patch.gz )"

SLOT="0"
LICENSE="ZSH"
KEYWORDS="~x86 -alpha ~ppc ~sparc"

DEPEND="ncurses? ( >=sys-libs/ncurses-5.1 )"

src_unpack() {
	unpack ${P}.tar.bz2
	epatch ${DISTDIR}/${ZSHALL}.bz2
	cd ${S}
	use cjk && epatch ${DISTDIR}/${P}-euc-0.2.patch.gz
}

src_compile() {
	local myconf

	use ncurses && myconf="--with-curses-terminfo"
	use maildir && myconf="${myconf} --enable-maildir-support"

	econf \
		--bindir=/bin \
		--libdir=/usr/lib \
		--enable-etcdir=/etc/zsh \
		--enable-zshenv=/etc/zsh/zshenv \
		--enable-zlogin=/etc/zsh/zlogin \
		--enable-zlogout=/etc/zsh/zlogout \
		--enable-zprofile=/etc/zsh/zprofile \
		--enable-zshrc=/etc/zsh/zshrc \
		--enable-fndir=/usr/share/zsh/${PV}/functions \
		--enable-site-fndir=/usr/share/zsh/site-functions \
		--enable-function-subdirs \
		${myconf} || die "configure failed"
	# emake still b0rks
	make || die "make failed"
	#make check || die "make check failed"
}

src_install() {
	einstall \
		bindir=${D}/bin \
		libdir=${D}/usr/lib \
		fndir=${D}/usr/share/zsh/${PV}/functions \
		sitefndir=${D}/usr/share/zsh/site-functions \
		install.bin install.man install.modules \
		install.info install.fns || die "make install failed"

	insinto /etc/zsh
	doins ${FILESDIR}/zprofile

	dodoc ChangeLog* META-FAQ README INSTALL LICENCE config.modules

	docinto StartupFiles
 	dodoc StartupFiles/z*
}

pkg_preinst() {
	# Our zprofile file does the job of the old zshenv file
	# Move the old version into a zprofile script so the normal
	# etc-update process will handle any changes.
	if [ -f /etc/zsh/zshenv -a ! -f /etc/zsh/zprofile ]; then
		mv /etc/zsh/zshenv /etc/zsh/zprofile
	fi
}
