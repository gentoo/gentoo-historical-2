# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh/zsh-4.3.2-r3.ebuild,v 1.2 2007/12/04 20:17:14 dertobi123 Exp $

inherit eutils multilib

LOVERS_PV=0.5
LOVERS_P=zsh-lovers-${LOVERS_PV}

DESCRIPTION="UNIX Shell similar to the Korn shell"
HOMEPAGE="http://www.zsh.org/"
SRC_URI="ftp://ftp.zsh.org/pub/${P}.tar.bz2
	examples? (
	http://www.grml.org/repos/zsh-lovers_${LOVERS_PV}.orig.tar.gz )
	doc? ( ftp://ftp.zsh.org/pub/${P}-doc.tar.bz2 )"

LICENSE="ZSH"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="maildir ncurses static doc examples pcre caps unicode"

RDEPEND="pcre? ( >=dev-libs/libpcre-3.9 )
	caps? ( sys-libs/libcap )
	ncurses? ( >=sys-libs/ncurses-5.1 )"
DEPEND="sys-apps/groff
	>=sys-apps/sed-4
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-init.d-gentoo.diff

	# fixes #201022 and
	# http://www.zsh.org/mla/workers/2007/msg01065.html
	rm Util/difflog.pl

	cd "${S}"/Doc
	ln -sf . man1
	# fix zshall problem with soelim
	soelim zshall.1 > zshall.1.soelim
	mv zshall.1.soelim zshall.1
}

src_compile() {
	local myconf

	use static && myconf="${myconf} --disable-dynamic" \
		&& LDFLAGS="${LDFLAGS} -static"

	econf \
		--bindir=/bin \
		--libdir=/usr/$(get_libdir) \
		--enable-etcdir=/etc/zsh \
		--enable-zshenv=/etc/zsh/zshenv \
		--enable-zlogin=/etc/zsh/zlogin \
		--enable-zlogout=/etc/zsh/zlogout \
		--enable-zprofile=/etc/zsh/zprofile \
		--enable-zshrc=/etc/zsh/zshrc \
		--enable-fndir=/usr/share/zsh/${PV%_*}/functions \
		--enable-site-fndir=/usr/share/zsh/site-functions \
		--enable-function-subdirs \
		--enable-ldflags="${LDFLAGS}" \
		--with-tcsetpgrp \
		$(use_with ncurses curses-terminfo) \
		$(use_enable maildir maildir-support) \
		$(use_enable pcre) \
		$(use_enable caps) \
		$(use_enable unicode multibyte) \
		${myconf} || die "configure failed"

	if use static ; then
		# compile all modules statically, see Bug #27392
		sed -i -e "s/link=no/link=static/g" \
			-e "s/load=no/load=yes/g" \
			config.modules || die
#	else
		# avoid linking to libs in /usr/lib, see Bug #27064
#		sed -i -e "/LIBS/s%-lpcre%/usr/$(get_libdir)/libpcre.a%" \
#			Makefile || die
	fi

	# emake still b0rks
	emake -j1 || die "make failed"
}

src_test() {
	for f in /dev/pt* ; do
		addpredict $f
	done
	make check || die "make check failed"
}

src_install() {
	einstall \
		bindir="${D}"/bin \
		libdir="${D}"/usr/$(get_libdir) \
		fndir="${D}"/usr/share/zsh/${PV%_*}/functions \
		sitefndir="${D}"/usr/share/zsh/site-functions \
		scriptdir="${D}"/usr/share/zsh/${PV%_*}/scripts \
		install.bin install.man install.modules \
		install.info install.fns || die "make install failed"

	insinto /etc/zsh
	doins "${FILESDIR}"/zprofile

	keepdir /usr/share/zsh/site-functions
	insinto /usr/share/zsh/${PV%_*}/functions/Prompts
	doins "${FILESDIR}"/prompt_gentoo_setup || die

	# install miscellaneous scripts; bug #54520
	sed -i -e "s:/usr/local:/usr:g" {Util,Misc}/* || "sed failed"
	insinto /usr/share/zsh/${PV%_*}/Util
	doins Util/* || die "doins Util scripts failed"
	insinto /usr/share/zsh/${PV%_*}/Misc
	doins Misc/* || die "doins Misc scripts failed"

	dodoc ChangeLog* META-FAQ README INSTALL LICENCE config.modules

	if use doc ; then
		dohtml Doc/*
		insinto /usr/share/doc/${PF}
		doins Doc/zsh.{dvi,pdf}
	fi

	if use examples; then
		cd "${WORKDIR}"/${LOVERS_P}
		doman  zsh-lovers.1    || die "doman zsh-lovers failed"
		dohtml zsh-lovers.html || die "dohtml zsh-lovers failed"
		docinto zsh-lovers
		dodoc zsh.vim README
		insinto /usr/share/doc/${PF}/zsh-lovers
		doins zsh-lovers.{ps,pdf} refcard.{dvi,ps,pdf}
		doins -r zsh_people || die "doins zsh_people failed"
		cd -
	fi

	docinto StartupFiles
	dodoc StartupFiles/z*
}

pkg_preinst() {
	# Our zprofile file does the job of the old zshenv file
	# Move the old version into a zprofile script so the normal
	# etc-update process will handle any changes.
	if [ -f "${ROOT}/etc/zsh/zshenv" -a ! -f "${ROOT}/etc/zsh/zprofile" ]; then
		ewarn "Renaming /etc/zsh/zshenv to /etc/zsh/zprofile."
		ewarn "The zprofile file does the job of the old zshenv file."
		mv "${ROOT}"/etc/zsh/{zshenv,zprofile}
	fi
}

pkg_postinst() {
	elog
	elog "If you want to enable Portage completions and Gentoo prompt,"
	elog "emerge app-shells/zsh-completion and add"
	elog "	autoload -U compinit promptinit"
	elog "	compinit"
	elog "	promptinit; prompt gentoo"
	elog "to your ~/.zshrc"
	elog
	elog "Also, if you want to enable cache for the completions, add"
	elog "	zstyle ':completion::complete:*' use-cache 1"
	elog "to your ~/.zshrc"
	elog
	# see Bug 26776
	ewarn
	ewarn "If you are upgrading from zsh-4.0.x you may need to"
	ewarn "remove all your old ~/.zcompdump files in order to use"
	ewarn "completion.  For more info see zcompsys manpage."
	ewarn
}
