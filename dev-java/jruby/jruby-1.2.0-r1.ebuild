# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jruby/jruby-1.2.0-r1.ebuild,v 1.4 2009/10/25 21:51:27 volkmar Exp $

EAPI="2"
JAVA_PKG_IUSE="doc source test"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java-based Ruby interpreter implementation"
HOMEPAGE="http://jruby.codehaus.org/"
SRC_URI="http://dist.codehaus.org/${PN}/${PV}/${PN}-src-${PV}.tar.gz"
LICENSE="|| ( CPL-1.0 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="bsf java6 ssl"

CDEPEND=">=dev-java/bytelist-1.0.2:0
	>=dev-java/constantine-0.5:0
	>=dev-java/jline-0.9.94:0
	>=dev-java/joni-1.1.3:0
	>=dev-java/jna-posix-1.0:0
	>=dev-java/jvyamlb-0.2.5:0
	dev-java/asm:3
	dev-java/jcodings:0
	dev-java/jffi:0
	dev-java/jna:0
	dev-java/joda-time:0
	dev-util/jay:0[java]
	!java6? ( dev-java/backport-util-concurrent )"

RDEPEND="${CDEPEND}
	!java6? ( =virtual/jre-1.5* )
	java6? ( >=virtual/jre-1.6 )"

# using 1.6 produces 1.6 bytecode, not sure why
DEPEND="${CDEPEND}
	!java6? ( =virtual/jdk-1.5* )
	java6? ( >=virtual/jdk-1.6 )
	bsf? ( dev-java/bsf:2.3 )
	test? (
		dev-java/ant-junit
		dev-java/ant-trax
	)"

PDEPEND="dev-ruby/rubygems
	>=dev-ruby/rake-0.7.3
	>=dev-ruby/rspec-1.0.4
	ssl? ( dev-ruby/jruby-openssl )"

RUBY_HOME=/usr/share/${PN}/lib/ruby
SITE_RUBY=${RUBY_HOME}/site_ruby
GEMS=${RUBY_HOME}/gems

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"
EANT_GENTOO_CLASSPATH="asm-3 bytelist constantine jay jcodings jffi jline joda-time joni jna jna-posix jvyamlb"
EANT_NEEDS_TOOLS="true"

pkg_setup() {
	java-pkg-2_pkg_setup
	use java6 || EANT_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH} backport-util-concurrent"

	local fail

	if [[ -d "${GEMS}" && ! -L "${GEMS}" ]]; then
		eerror "${GEMS} is a directory. Please remove this directory."
		fail="true"
	fi

	# the symlink creates a collision with rubygems, bug #270953
	# cannot be currently solved by removing in pkg_preinst, bug #233278
	if [[ -L "${SITE_RUBY}" ]]; then
		eerror "${SITE_RUBY} is a symlink. Please remove this symlink."
		fail="true"
	fi

	if [[ -n ${fail} ]]; then
		eerror "Unmerging the old jruby version should also fix the problem(s)."
		die "Please address the above errors, then run emerge --resume"
	fi
}

java_prepare() {
	epatch "${FILESDIR}/ftype-test-fixes.patch"
	epatch "${FILESDIR}/user-test-fixes.patch"

	# We don't need to use Retroweaver. There is a jarjar and a regular jar
	# target but even with jarjarclean, both are a pain. The latter target
	# is slightly easier so go with this one.
	sed -r -i \
		-e 's/maxmemory="128m"/maxmemory="192m"/' \
		-e "/RetroWeaverTask/d" \
		-e "/<zipfileset .+\/>/d" \
		build.xml || die

	# Delete the bundled JARs but keep invokedynamic.jar.
	# No source is available and it's only a dummy anyway.
	find build_lib lib -name "*.jar" ! -name "invokedynamic.jar" -delete || die

	if ! use bsf; then
		# Remove BSF test cases.
		cd "${S}/test/org/jruby"
		rm -f test/TestAdoptedThreading.java || die
		rm -f javasupport/test/TestBSF.java || die
		sed -i '/TestBSF.class/d' javasupport/test/JavaSupportTestSuite.java || die
		sed -i '/TestAdoptedThreading.class/d' test/MainTestSuite.java || die
	fi
}

src_compile() {
	eant jar $(use_doc create-apidocs) -Djdk1.5+=true
}

src_test() {
	if [ ${UID} == 0 ] ; then
		ewarn 'The tests will fail if run as root so skipping them.'
		ewarn 'Enable FEATURES="userpriv" if you want to run them.'
		return
	fi

	# BSF is a compile-time only dependency because it's just the adapter
	# classes and they won't be used unless invoked from BSF itself.
	use bsf && java-pkg_jar-from --into build_lib --with-dependencies bsf-2.3

	# Our jruby.jar is unbundled so we need to add the classpath to this test.
	sed -i "s:java -jar:java -Xbootclasspath/a\:#{ENV['JRUBY_CP']} -jar:g" test/test_load_compiled_ruby_class_from_classpath.rb || die

	ANT_TASKS="ant-junit ant-trax" JRUBY_CP=`java-pkg_getjars ${EANT_GENTOO_CLASSPATH// /,}` JRUBY_OPTS="" eant test -Djdk1.5+=true
}

src_install() {
	local bin

	java-pkg_dojar lib/${PN}.jar
	dodoc README docs/{*.txt,README.*} || die

	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/org

	dobin "${FILESDIR}/jruby" || die
	exeinto "/usr/share/${PN}/bin"
	doexe "${S}/bin/jruby" || die

	# Install some jruby tools.
	dobin "${S}"/bin/j{gem,irb{,_swing},rubyc} || die

	# Symlink some common tools so that jruby can launch them internally.
	for bin in {j,}gem jirb jrubyc rake rdoc ri spec{,_translator} ; do
		dosym "/usr/bin/${bin}" "/usr/share/${PN}/bin/${bin}" || die
	done

	insinto "${RUBY_HOME}"
	doins -r "${S}/lib/ruby/1.8" || die
	doins -r "${S}/lib/ruby/site_ruby" || die

	# Share gems with regular Ruby.
	dosym /usr/$(get_libdir)/ruby/gems "${GEMS}" || die

	# Autoload rubygems and append regular site_ruby to $LOAD_PATH.
	# Unfortunately the -I option prepends instead.
	insinto "${SITE_RUBY}"
	doins "${FILESDIR}/gentoo.rb" || die
	doenvd "${FILESDIR}/10jruby" || die
}
