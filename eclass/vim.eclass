# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/vim.eclass,v 1.45 2003/12/09 00:26:33 tester Exp $

# Authors:
# 	Ryan Phillips <rphillips@gentoo.org>
# 	Seemant Kulleen <seemant@gentoo.org>
# 	Aron Griffis <agriffis@gentoo.org>

inherit eutils vim-doc
ECLASS=vim
INHERITED="$INHERITED $ECLASS"
EXPORT_FUNCTIONS src_unpack

IUSE="$IUSE ncurses nls acl"
if [ ${PN} != vim-core ]; then
	IUSE="$IUSE cscope gpm perl python ruby"
	DEPEND="$DEPEND
		cscope?  ( dev-util/cscope )
		gpm?     ( >=sys-libs/gpm-1.19.3 )
		perl?    ( dev-lang/perl )
		python?  ( dev-lang/python )
		acl?     ( sys-apps/acl )"
	RDEPEND="$RDEPEND
		cscope?  ( dev-util/cscope )
		gpm?     ( >=sys-libs/gpm-1.19.3 )
		perl?    ( dev-lang/perl )
		python?  ( dev-lang/python )
		acl?     ( sys-apps/acl )"
	# Vim versions after 6.2d should work with Ruby 1.8 because of a local
	# Gentoo patch; working on putting it upstream (22 May 2003 agriffis)
	if [[ "$PV" < 6.2 || ( "$PV" == 6.2_pre* && "${PV#*pre}" -lt 4 ) ]]; then
		DEPEND="$DEPEND ruby? ( =dev-lang/ruby-1.6* )" # 1.8 doesn't work
		RDEPEND="$RDEPEND ruby? ( =dev-lang/ruby-1.6* )"
	else
		DEPEND="$DEPEND ruby? ( dev-lang/ruby )"
		RDEPEND="$RDEPEND ruby? ( dev-lang/ruby )"
	fi

	if [ ${PN} = vim ]; then
		IUSE="$IUSE vim-with-x minimal"
		DEPEND="$DEPEND vim-with-x? ( virtual/x11 )"
		RDEPEND="$RDEPEND vim-with-x? ( virtual/x11 )"
	elif [ ${PN} = gvim ]; then
		IUSE="$IUSE gnome gtk gtk2 motif"
	fi
fi

HOMEPAGE="http://www.vim.org/"
SLOT="0"
LICENSE="vim"

# Portage dependancy is for use_with/use_enable.
# ctags dependancy allows help tags to be rebuilt properly, along
# with detection of exuberant-ctags by configure.
DEPEND="$DEPEND 
	>=sys-apps/portage-2.0.45-r3
	>=sys-apps/sed-4
	sys-devel/autoconf
	ncurses? ( >=sys-libs/ncurses-5.2-r2 ) : ( sys-libs/libtermcap-compat )
	dev-util/ctags
	"
RDEPEND="$RDEPEND 
	ncurses? ( >=sys-libs/ncurses-5.2-r2 ) : ( sys-libs/libtermcap-compat )
	dev-util/ctags
	"

apply_vim_patches() {
	local p
	cd ${S} || die "cd ${S} failed"

	# Scan the patches, applying them only to files that either
	# already exist or that will be created by the patch
	einfo "Filtering vim patches..."
	p=${WORKDIR}/${VIM_ORG_PATCHES%.tar*}.patch
	ls ${WORKDIR}/vimpatches | sort | \
	xargs -i gzip -dc ${WORKDIR}/vimpatches/{} | awk '
		/^Subject: Patch/ {
			if (patchnum) {printf "\n" >"/dev/stderr"}
			patchnum = $3
			printf "%s:", patchnum >"/dev/stderr"
		}
		$1=="***" && $(NF-1)~/^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$/ {
			# First line of a patch; suppress printing
			firstlines = $0
			next
		}
		$1=="---" && $(NF-1)~/^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$/ {
			# Second line of a patch; try to open the file to see
			# if it exists.
			thisfile = $2
			if (!seen[thisfile] && (getline tryme < thisfile) == -1) {
				# Check if it will be created
				firstlines = firstlines "\n" $0
				getline
				firstlines = firstlines "\n" $0
				getline
				if ($0 != "*** 0 ****") {
					# Non-existent and not created, stop printing
					printing = 0
					printf " (%s)", thisfile >"/dev/stderr"
					next
				}
			}
			# Print the previous lines and start printing
			print firstlines
			printing = 1
			printf " %s", thisfile >"/dev/stderr"
			# Remember that we have seen this file
			seen[thisfile] = 1
		}
		printing { print }
		END { if (patchnum) {printf "\n" >"/dev/stderr"} }
		' > ${p} || die

	# For reasons yet unknown, epatch fails to apply this cleanly
	ebegin "Applying filtered vim patches..."
	TMPDIR=${T} patch -f -s -p0 < ${p}
	eend 0
}

vim_src_unpack() {
	unpack ${A}

	# Apply any patches available from vim.org for this version
	[ -n "$VIM_ORG_PATCHES" ] && apply_vim_patches

	# Another set of patches borrowed from src rpm to fix syntax errors etc.
	cd ${S} || die "cd ${S} failed"
	EPATCH_SUFFIX="gz" EPATCH_FORCE="yes" \
		epatch ${WORKDIR}/gentoo/patches-all/

	# Fixup a script to use awk instead of nawk
	sed -i '1s|.*|#!/usr/bin/awk -f|' ${S}/runtime/tools/mve.awk \
		|| die "mve.awk sed failed"

	# Patch to build with ruby-1.8.0_pre5 and following
	sed -i 's/defout/stdout/g' ${S}/src/if_ruby.c

	# Read vimrc and gvimrc from /etc/vim
	echo '#define SYS_VIMRC_FILE "/etc/vim/vimrc"' >> ${S}/src/feature.h
	echo '#define SYS_GVIMRC_FILE "/etc/vim/gvimrc"' >> ${S}/src/feature.h

	# Use exuberant ctags which installs as /usr/bin/exuberant-ctags.
	# Hopefully this pattern won't break for a while at least.
	# This fixes bug 29398 (27 Sep 2003 agriffis)
	sed -i 's/\<ctags\("\| [-*.]\)/exuberant-&/g' \
		${S}/runtime/doc/syntax.txt \
		${S}/runtime/doc/tagsrch.txt \
		${S}/runtime/doc/usr_29.txt \
		${S}/runtime/menu.vim \
		${S}/src/configure.in
}

src_compile() {
	local myconf confrule

	# Fix bug #18245: Prevent "make" from the following chain:
	# (1) Notice configure.in is newer than auto/configure
	# (2) Rebuild auto/configure
	# (3) Notice auto/configure is newer than auto/config.mk
	# (4) Run ./configure (with wrong args) to remake auto/config.mk
	sed -i 's/ auto.config.mk:/:/' src/Makefile || die "Makefile sed failed"
	rm -f src/auto/configure
	# vim-6.2 changed the name of this rule from auto/configure to autoconf
	confrule=auto/configure
	grep -q ^autoconf: src/Makefile && confrule=autoconf
	# autoconf-2.5 needed for AC_PROG_EGREP -- bug 35319
	WANT_AUTOCONF_2_5=1 make -C src $confrule || die "make $confrule failed"

	# This should fix a sandbox violation (see bug 24447)
	for file in /dev/pty/s* /dev/console; do
		addwrite $file
	done

	if [ ${PN} = vim-core ] || ( [ ${PN} = vim ] && use minimal ); then
		myconf="--with-features=tiny \
			--enable-gui=no \
			--without-x \
			--disable-perlinterp \
			--disable-pythoninterp \
			--disable-rubyinterp \
			--disable-gpm"
	else
		myconf="--with-features=huge \
			--enable-multibyte"
		myconf="${myconf} `use_enable cscope`"
		myconf="${myconf} `use_enable gpm`"
		myconf="${myconf} `use_enable perl perlinterp`"
		myconf="${myconf} `use_enable python pythoninterp`"
		myconf="${myconf} `use_enable ruby rubyinterp`"
		# tclinterp is broken; when you --enable-tclinterp flag, then
		# the following command never returns:
		#   VIMINIT='let OS=system("uname -s")' vim
		#myconf="${myconf} `use_enable tcl tclinterp`"

		if [ ${PN} = vim ]; then
			# don't test USE=X here... see bug #19115
			# but need to provide a way to link against X... see bug #20093
			myconf="${myconf} --enable-gui=no `use_with vim-with-x x`"
		elif [ ${PN} = gvim ]; then
			myconf="${myconf} --with-vim-name=gvim --with-x"
			if use gtk && use gtk2; then
				myconf="${myconf} --enable-gui=gtk2 --enable-gtk2-check"
			elif use gnome; then
				myconf="${myconf} --enable-gui=gnome"
			elif use gtk; then
				myconf="${myconf} --enable-gui=gtk"
			elif use motif; then
				myconf="${myconf} --enable-gui=motif"
			else
				myconf="${myconf} --enable-gui=athena"
			fi
		else
			die "vim.eclass doesn't understand PN=${PN}"
		fi
	fi

	if [ ${PN} = vim ] && use minimal; then
		myconf="${myconf} --disable-nls --disable-multibyte --disable-acl"
	else
		myconf="${myconf} `use_enable nls` `use_enable acl`"
	fi

	# Note: If USE=gpm, then ncurses will still be required
	use ncurses \
		&& myconf="${myconf} --with-tlib=ncurses" \
		|| myconf="${myconf} --with-tlib=termcap"

	econf ${myconf} || die "vim configure failed"

	# The following allows emake to be used
	make -C src auto/osdef.h objects || die "make failed"

	if [ "${PN}" = "vim-core" ]; then
		emake tools || die "emake tools failed"
		rm -f src/vim
	else
		emake || die "emake failed"
	fi
}

src_install() {
	if [ "${PN}" = "vim-core" ]; then
		dodir /usr/{bin,share/{man/man1,vim}}
		cd src || die "cd src failed"
		make \
			installruntime \
			installhelplinks \
			installmacros \
			installtutor \
			installtools \
			install-languages \
			install-icons \
			DESTDIR=${D} \
			BINDIR=/usr/bin \
			MANDIR=/usr/share/man \
			DATADIR=/usr/share \
			|| die "install failed"

		keepdir /usr/share/vim/vim${VIM_VERSION/.}/keymap

		# Azarah put in the below "fix" in early 2002 but it makes
		# things painful when going from 6.1->6.2a, etc.  It also
		# seems to be completely unnecessary, so I'm removing it.
		# (24 Apr 2003 agriffis)
		#
		# fix problems with vim not finding its data files.
		#echo "VIMRUNTIME=/usr/share/vim/vim${VIM_VERSION/.}" > 40vim
		#insinto /etc/env.d
		#doins 40vim

		# default vimrc is installed by vim-core since it applies to
		# both vim and gvim
		insinto /etc/vim/
		doins ${FILESDIR}/vimrc
	elif [ "${PN}" = "gvim" ]; then
		dobin src/gvim
		dosym gvim /usr/bin/gvimdiff
		insinto /etc/vim
		doins ${FILESDIR}/gvimrc
	else
		dobin src/vim
		ln -s vim ${D}/usr/bin/vimdiff && \
		ln -s vim ${D}/usr/bin/rvim && \
		ln -s vim ${D}/usr/bin/ex && \
		ln -s vim ${D}/usr/bin/view && \
		ln -s vim ${D}/usr/bin/rview \
			|| die "/usr/bin symlinks failed"
	fi
}

pkg_postinst() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags

	einfo
	if [ ${PN} = gvim ]; then
		einfo "To enable UTF-8 viewing, set guifont and guifontwide: "
		einfo ":set guifont=-misc-fixed-medium-r-normal-*-18-120-100-100-c-90-iso10646-1"
		einfo ":set guifontwide=-misc-fixed-medium-r-normal-*-18-120-100-100-c-180-iso10646-1"
		einfo
		einfo "note: to find out which fonts you can use, please read the UTF-8 help:"
		einfo ":h utf-8"
		einfo
		einfo "Then, set read encoding to UTF-8:"
		einfo ":set encoding=utf-8"
	elif [ ${PN} = vim ]; then
		einfo "gvim has now a seperate ebuild, 'emerge gvim' will install gvim"
	fi
	einfo

	# Warn about VIMRUNTIME
	if [ -n "$VIMRUNTIME" -a "${VIMRUNTIME##*/vim}" != "${VIM_VERSION/.}" ]; then
		ewarn
		ewarn "WARNING: You have VIMRUNTIME set in your environment from an old"
		ewarn "installation.  You will need to either unset VIMRUNTIME in each"
		ewarn "terminal, or log out completely and back in.  This problem won't"
		ewarn "happen again since the ebuild no longer sets VIMRUNTIME."
		ewarn
	fi

	# Make convenience symlinks, hopefully without stepping on toes
	[ -f /usr/bin/gvim ] && ln -s gvim /usr/bin/vim 2>/dev/null
	[ -f /usr/bin/vim ] && ln -s vim /usr/bin/vi 2>/dev/null
}

pkg_postrm() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags
}
