# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/ruby.eclass,v 1.34 2004/06/24 07:11:54 usata Exp $
#
# Author: Mamoru KOMACHI <usata@gentoo.org>
#
# The ruby eclass is designed to allow easier installation of ruby
# softwares, and their incorporation into the Gentoo Linux system.

# src_unpack, src_compile and src_install call a set of functions to emerge
# ruby with SLOT support; econf, emake and einstall is a wrapper for ruby
# to automate configuration, make and install process (they override default
# econf, emake and einstall defined by ebuild.sh respectively).

# Functions:
# src_unpack	Unpacks source archive(s) and apply patches if any.
# src_compile	Invokes econf and emake.
# src_install	Runs einstall and erubydoc.
# econf		Detects setup.rb, install.rb, extconf.rb and configure,
#		and then runs the configure script.
# emake		Runs make if any Makefile exists.
# einstall	Calls install script or Makefile. If both not present,
#		installs programs under sitedir.
# erubydoc	Finds any documents and puts them in the right place.
#		erubydoc needs more sophistication to handle all types of
#		appropriate documents.

# Variables:
# USE_RUBY	Space delimited list of supported ruby.
#		Set it to "any" if it installs only version independent files.
#		If your ebuild supports both ruby 1.6 and 1.8 but has version
#		depenedent files such as libraries, set it to something like
#		"ruby16 ruby18". Possible values are "any ruby16 ruby18 ruby19"
# EXTRA_ECONF	You can pass extra arguments to econf by defining this
#		variable. Note that you cannot specify them by command line
#		if you are using <sys-apps/portage-2.0.49-r17.
# PATCHES	Space delimited list of patch files.

inherit eutils

ECLASS=ruby
INHERITED="${INHERITED} ${ECLASS}"
EXPORT_FUNCTIONS src_unpack src_compile src_install prepall \
	econf emake einstall erubyconf erubymake erubyinstall erubydoc

HOMEPAGE="http://raa.ruby-lang.org/list.rhtml?name=${PN}"
SRC_URI="mirror://gentoo/${P}.tar.gz"

IUSE="${IUSE}"

SLOT="0"
LICENSE="Ruby"

DEPEND="virtual/ruby"

[[ -z "${RUBY}" ]] && export RUBY=/usr/bin/ruby

ruby_src_unpack() {

	unpack ${A}
	cd ${S}
	# apply bulk patches
	if [[ -n "${PATCHES}" ]] ; then
		for p in ${PATCHES} ; do
			epatch $p
		done
	fi
}

ruby_econf() {

	if [ -f configure ] ; then
		./configure \
			--prefix=/usr \
			--host=${CHOST} \
			--mandir=/usr/share/man \
			--infodir=/usr/share/info \
			--datadir=/usr/share \
			--sysconfdir=/etc \
			--localstatedir=/var/lib \
			--with-ruby=${RUBY} \
			${EXTRA_ECONF} \
			"$@" || die "econf failed"
	fi
	if [ -f install.rb ] ; then
		${RUBY} install.rb config --prefix=/usr "$@" \
			|| die "install.rb config failed"
		${RUBY} install.rb setup "$@" \
			|| die "install.rb setup failed"
	fi
	if [ -f setup.rb ] ; then
		${RUBY} setup.rb config --prefix=/usr "$@" \
			|| die "setup.rb config failed"
		${RUBY} setup.rb setup "$@" \
			|| die "setup.rb setup failed"
	fi
	if [ -f extconf.rb ] ; then
		${RUBY} extconf.rb "$@" || die "extconf.rb failed"
	fi
}

ruby_emake() {
	if [ -f makefiles -o -f GNUmakefile -o -f makefile -o -f Makefile ] ; then
		make CC=${CC:-gcc} CXX=${CXX:-g++} "$@" || die "emake for ruby failed"
	fi
}

ruby_src_compile() {

	# You can pass configure options via EXTRA_ECONF
	ruby_econf || die
	ruby_emake "$@" || die
}

ruby_einstall() {
	local siteruby

	if [ -f install.rb ] ; then
		${RUBY} install.rb config --prefix=${D}/usr "$@" \
			|| die "install.rb config failed"
		${RUBY} install.rb install "$@" \
			|| die "install.rb install failed"
	elif [ -f setup.rb ] ; then
		${RUBY} setup.rb config --prefix=${D}/usr "$@" \
			|| die "setup.rb config failed"
		${RUBY} setup.rb install "$@" \
			|| die "setup.rb install failed"
	elif [ -f extconf.rb -o -f Makefile ] ; then
		make DESTDIR=${D} "$@" install || die "make install failed"
	else
		siteruby=$(${RUBY} -r rbconfig -e 'print Config::CONFIG["sitedir"]')
		insinto ${siteruby}
		doins *.rb || die "doins failed"
	fi
}

erubydoc() {
	local rdbase=/usr/share/doc/${PF}/rd rdfiles=$(find . -name '*.rd*')

	einfo "running dodoc for ruby ;)"

	insinto ${rdbase}
	[ -n "${rdfiles}" ] && doins ${rdfiles}
	rmdir --ignore-fail-on-non-empty ${D}${rdbase}
	if [ -d doc -o -d docs ] ; then
		dohtml -x html -r {doc,docs}/*
		dohtml -r {doc,docs}/html/*
	else
		dohtml -r *
	fi
	for dir in sample example examples; do
		if [ -d ${dir} ] ; then
			dodir /usr/share/doc/${PF}
			cp -a ${dir} ${D}/usr/share/doc/${PF} || die "cp failed"
		fi
	done
	for i in ChangeLog* [A-Z][A-Z]* ; do
		[ -e $i ] && dodoc $i
	done
}

ruby_src_install() {

	ruby_einstall "$@" || die

	erubydoc
}

# erubyconf, erubymake and erubyinstall are kept for compatibility
erubyconf() {
	ruby_econf "$@"
}

erubymake() {
	ruby_emake "$@"
}

erubyinstall() {
	ruby_einstall "$@"
}

# prepall adds SLOT support for ruby.eclass
prepall() {

	[[ ! -x /usr/bin/ruby16 ]] && export USE_RUBY=${USE_RUBY/ruby16/}
	[[ ! -x /usr/bin/ruby18 ]] && export USE_RUBY=${USE_RUBY/ruby18/}
	[[ ! -x /usr/bin/ruby19 ]] && export USE_RUBY=${USE_RUBY/ruby19/}

	if [ $(echo "${USE_RUBY}" | wc -w) -ge 2 ] ; then
		einfo "Now we are building the package for ${USE_RUBY}"
		for rb in ${USE_RUBY} ruby ; do
			einfo "Using $rb"
			export RUBY=/usr/bin/$rb
			ruby() { /usr/bin/$rb "$@" ; }
			mkdir -p ${S}
			cd ${WORKDIR}
			einfo "Unpacking for $rb"
			src_unpack || die "src_unpack failed"
			cd ${S}
			find . -name '*.[ao]' -exec rm {} \;
			einfo "Building for $rb"
			src_compile || die "src_compile failed"
			cd ${S}
			einfo "Installing for $rb"
			src_install || die "src_install failed"
		done
	elif [ "${USE_RUBY}" == "any" ] ; then
		siteruby=$(${RUBY} -r rbconfig -e 'print Config::CONFIG["sitelibdir"]')
		# in case no directories found in siteruby
		shopt -sq nullglob

		for x in ${D}/${siteruby}/* ; do
			mv $x ${D}/${siteruby}/..
		done
		if [ -d ${D}${siteruby} ] ; then
			rmdir --ignore-fail-on-non-empty ${D}/${siteruby}
		fi
	fi

	prepallman
	prepallinfo
	prepallstrip
}

