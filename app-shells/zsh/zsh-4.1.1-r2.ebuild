# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh/zsh-4.1.1-r2.ebuild,v 1.3 2003/09/11 01:03:59 msterret Exp $

inherit eutils

IUSE="cjk maildir ncurses static"

DESCRIPTION="UNIX Shell similar to the Korn shell"
HOMEPAGE="http://www.zsh.org/"

SRC_URI="ftp://ftp.zsh.org/pub/${P}.tar.bz2
	cjk? ( http://www.ono.org/software/dist/${P}-euc-0.2.patch.gz )"

SLOT="0"
LICENSE="ZSH"
# 4.1.x branch is still a development release, though I think it is fairly
# stable and we may unmask it in the not-so-distant future
KEYWORDS="~x86 ~alpha ~ppc ~sparc"

DEPEND="sys-apps/groff
	>=dev-libs/libpcre-3.9
	>=sys-apps/sed-4
	sys-libs/libcap
	ncurses? ( >=sys-libs/ncurses-5.1 )"
RDEPEND=">=dev-libs/libpcre-3.9
	sys-libs/libcap
	ncurses? ( >=sys-libs/ncurses-5.1 )"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
	use cjk && epatch ${DISTDIR}/${P}-euc-0.2.patch.gz
	cd ${S}/Doc
	ln -sf . man1
	# fix zshall problem with soelim
	soelim zshall.1 > zshall.1.soelim
	mv zshall.1.soelim zshall.1
}

src_compile() {
	local myconf

	use ncurses && myconf="--with-curses-terminfo"
	use maildir && myconf="${myconf} --enable-maildir-support"
	use static && myconf="${myconf} --disable-dynamic" \
		&& LDFLAGS="${LDFLAGS} -static"

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
		--enable-ldflags="${LDFLAGS}" \
		${myconf} || die "configure failed"

	if [ -n "`use static`" ] ; then
		# compile all modules statically, see Bug #27392
		sed -i -e "s/link=no/link=static/g" \
			-e "s/load=no/load=yes/g" \
			config.modules || die
	else
		# avoid linking to libs in /usr/lib, see Bug #27064
		sed -i -e "/LIBS/s%-lpcre%/usr/lib/libpcre.a%" \
			Makefile || die
	fi

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

pkg_postinst() {

	# see Bug 26776
	ewarn
	ewarn "If you are upgrading from zsh-4.0.x you may need to"
	ewarn "remove all your old ~/.zcompdump files in order to use"
	ewarn "completion.  For more info see zcompsys manpage."
	ewarn
}
